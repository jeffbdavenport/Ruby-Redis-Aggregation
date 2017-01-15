require 'open-uri'
require 'nokogiri'
module Aggregate
  # Downloads files from url
  class Download
    attr_reader :links, :downloaded
    def initialize(args)
      Arguments.valid? args: args, valid: [:path, :url, :redis, :list]
      @path = args[:path] ||= 'tmp'
      @url =  args[:url]
      @list = args[:list] || CONF.download.redis.list
      @all_links = []
      @local_links = []
      @downloaded = 0
      save_links
    end

    # Add all href links on the page to an array
    def links(type = :local)
      @links = type == :all ? @all_links : @local_links
    end

    # Download all refs
    def download_all
      @links.each do |file|
        download(file)
      end
    end

    # Download one
    def download_one
      @links.each do |file|
        download(file) unless @downloaded.positive?
      end
    end

    # Download a local file
    def download(file)
      return unless download?(file)
      open(path(file), 'wb') do |f|
        puts LOC.en.download.downloading % { url: url(file), file: path(file) }
        f << open(url(file)).read
        @downloaded += 1
      end
    end

    # File path
    def path(file)
      File.join(@path, file)
    end

    # File URL
    def url(file)
      URI.join(@url, file)
    end

    private

    def download?(file)
      return false if File.exist? path(file)
      @data = ManageData.new data: url(file), list: @list
      return false if @data.exists?
      @data.sadd
      true
    end

    def save_links
      @all_links = Nokogiri::HTML(open(@url)).css('a').map do |a|
        a.attr 'href'
      end.compact
      @local_links = @all_links.select do |link|
        link =~ /\A[[:alnum:].]++\z/
      end
      links
      raise "Could not get any links from #{@url}" if @all_links.empty?
    end
  end
end
