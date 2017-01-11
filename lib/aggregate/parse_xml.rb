require 'nokogiri'
# Downloads files from url
class ParseXML
  def initialize(args)
    Arguments.valid? args: args, valid: :xml_data
    @xml = args[:xml_data]
  end
end
