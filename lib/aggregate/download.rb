require 'open-uri'
require 'nokogiri'
module Aggregate
  # Downloads files from url
  class Download
    attr_reader :links, :downloaded
    def initialize(args = {})
      Arguments.valid? args: args, valid: [:path, :url, :redis, :list]
      @path = args[:path] ||= 'tmp'
      @url =  args[:url] || CONF.download.url
      @list = args[:list] || CONF.download.redis.list
      @downloaded = 0
      @thread_count = 0
      @mutex = Mutex.new
      @wait = Mutex.new
      save_links
    end

    # Add all href links on the page to an array
    def links(type = :local)
      @links = type == :all ? @all_links : @local_links
    end

    # Download all refs
    def download_all
      @threads = []
      @count = 0
      @links.each do |file|
        multi_download(file) do |f|
          yield(f)
        end
      end
      @threads.each(&:join)
    end

    # Download one
    def download_one
      @links.each do |file|
        break if @downloaded.positive?
        download(file)
      end
    end

    # Download files in seperate threads
    def multi_download(file)
      return unless file.download?
      @threads[@threads.count] = Thread.new do
        wait
        download(file)
        finish_wait
        @mutex.synchronize do
          yield(file)
        end
      end
    end

    # Download a file
    def download(file)
      return unless file.download?
      @mutex.synchronize do
        puts format LOC.en.download.downloading, url: file.url, file: file.path
      end
      file.rm_part
      # Change to segments(file) for large downloads
      segments(file)
      @mutex.synchronize { @downloaded += 1 }
      file.save_part
      file.add_to_redis
    end

    private

    def finish_wait
      @mutex.synchronize do
        @count -= 1
      end
    end

    # Wait for other threads to complete
    def wait
      @wait.synchronize do
        sleep 1 while @count >= THREAD_MAX
        @count += 1
      end
    end

    # Fast but saves entire file to memory before saving
    def quick(file)
      open(file.part, 'wb') do |f|
        f << open(file.url).read
      end
    end

    # Preferable for very large files
    def segments(file)
      Net::HTTP.start 'feed.omgili.com' do |http|
        http.request_get('/5Rh5AMTrc4Pv/mainstream/posts/' + file.file) do |resp|
          resp.read_body do |segment|
            open(file.part, 'ab') { |f| f.write(segment) }
          end
        end
      end
    end

    def save_links
      @all_links = Nokogiri::HTML(open(@url)).css('a').map do |a|
        a.attr('href')
      end.compact.sort
      @local_links = @all_links.map do |link|
        if link =~ /\A[[:alnum:].]++\z/
          TmpFile.new file: link, path: @path
        end
      end.compact
      links
      raise "Could not get any links from #{@url}" if @all_links.empty?
    end
  end
end
