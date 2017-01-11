require 'open-uri'
require 'nokogiri'
module Aggregate
  # Downloads files from url
  class Download
    attr_reader :links
    def initialize(args)
      Arguments.validate(self, args, :path, :url)
      @path = args[:path] ||= 'tmp'
      Dir.mkdir @path unless File.exist?(@path)
      @url = args[:url]
    end

    # Add all href links on the page to an array
    def page_hrefs(regex = nil)
      @links = Nokogiri::HTML(open(@url)).css('a').map do |a|
        href = a.attr 'href'
        return href if regex.nil?
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

    # Download a local file
    def download(file)
      return if file.nil?
      path = File.join(@path, file)
      return if File.exist?(path)
      open(path, 'wb') do |f|
        f << open(URI.join(@url, file)).read
      end
    end
  end
end
