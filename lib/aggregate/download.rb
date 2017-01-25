require 'open-uri'
require 'nokogiri'
module Aggregate
  # Downloads files from url
  class Download
    LOC = LOC.en.download
    CONF = CONF.download
    attr_accessor :downloaded
    attr_reader :links
    def initialize(args = {})
      Arguments.valid? args, :path, :url, :redis, :list
      Arguments.fill args, CONF,       :path, :url
      Arguments.fill args, CONF.redis, :list
      @path = args[:path]
      @url  = URI(args[:url])
      @list = args[:list]
      @downloaded = @thread_count = 0
      @mutex = (@wait = Mutex.new).dup # Assign uniqe Mutex to each
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
        puts format LOC.downloading, url: file.url, file: file.path
      end
      file.rm_part
      return false unless segments(file)
      @mutex.synchronize { @downloaded += 1 }
      file.save_part
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

    # Preferable for large files
    def segments(file)
      Net::HTTP.start @url.host do |http|
        http.request_get(@url.path + file.file) do |resp|
          if resp.code != '200'
            warn "Could not download #{@url + file.file}, page returned #{resp.code}"
            return false
          end
          resp.read_body do |segment|
            open(file.part, 'ab') { |f| f.write(segment) }
          end
        end
      end
      true
    end

    # Save hrefs from @url to an array of TmpFiles
    def save_links
      @all_links = Nokogiri::HTML(open(@url)).css('a').map do |a|
        a.attr('href')
      end.compact.sort
      @local_links = @all_links.map do |link|
        TmpFile.new file: link, path: @path, list: @list if link =~ /\A[[:alnum:].]++\z/
      end.compact
      links
      raise "Could not get any links from #{@url}" if @all_links.empty?
    end
  end
end
