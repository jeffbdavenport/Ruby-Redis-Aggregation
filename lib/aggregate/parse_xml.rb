require 'nokogiri'
# Downloads files from url
class ParseXML
  def initialize(args)
    Arguments.valid? args: args, valid: [:file, :xml_data]
    @xml = args[:xml_data]
    @xml ||= File.read args[:file]
    @xml = Nokogiri::XML @xml
  end
end
