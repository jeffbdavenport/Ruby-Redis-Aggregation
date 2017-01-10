# frozen_string_literal: true
require 'open-uri'
require 'nokogiri'
# Downloads files from url
class Download
  attr_reader :links
  def initialize(args)
    @path = args[:path] ||= 'tmp'
    Dir.mkdir @path unless File.exist?(@path)
    @url = args[:url]
    local_page_links
    $stderr.puts @links
    download @links[0]
  end
end

# Add all href links on the page to an array
def local_page_links
  @links = Nokogiri::HTML(open(@url)).css('a').map do |a|
    href = a.attr 'href'
    href =~ %r{[^\/]+\.[[:alnum:]]+\z} ? href : nil
  end.compact
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
