require 'open-uri'
require 'nokogiri'
module Aggregate
  # Downloads files from url
  class Download
    attr_reader :links, :downloaded
    def initialize(args)
      Arguments.valid? args: args, valid: [:path, :url]
      @path = args[:path] ||= 'tmp'
      @url = args[:url]
      @links = []
      @downloaded = 0
    end

    # Add all href links on the page to an array
    def page_hrefs(regex = /\A./)
      @links = Nokogiri::HTML(open(@url)).css('a').map do |a|
        href = a.attr 'href'
        href =~ regex ? href : nil
      end.compact
    end

    # Store only local file hrefs
    def local_file_hrefs
      page_hrefs %r{[^/]+\.[[:alnum:]]+\z}
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
      return if file.nil?
      path = File.join(@path, file)
      return if File.exist?(path)
      open(path, 'wb') do |f|
        url = URI.join(@url, file)
        puts LOC.download.downloading % { url: url, file: path }
        f << open(url).read
        @downloaded += 1
      end
    end
  end
end
