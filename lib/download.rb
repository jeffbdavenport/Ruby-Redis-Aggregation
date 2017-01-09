# frozen_string_literal: true
require 'open-uri'
require 'nokogiri'
# Downloads files from url
class Download
  attr_reader :links
  def initialize(args)
    @tmp = args[:tmp] ||= 'tmp'
    Dir.mkdir @tmp unless File.exist?(@tmp)
    @url = args[:url]
    links
  end
end

def links
  @links = Nokogiri::HTML(open(@url)).css('a').map do |a|
    a.attr 'href'
  end.compact.uniq
end

#open('image.png', 'wb') do |file|
#  file << open('http://example.com/image.png').read
#end
