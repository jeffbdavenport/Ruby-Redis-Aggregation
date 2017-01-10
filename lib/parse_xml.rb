# frozen_string_literal: true
require 'nokogiri'
require 'zip'
# Downloads files from url
class ParseXML
  def initialize(xml_data)
    @xml = xml_data
  end
end
