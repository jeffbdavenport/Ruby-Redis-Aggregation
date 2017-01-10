# frozen_string_literal: true
$LOAD_PATH.unshift Dir.pwd
$LOAD_PATH.unshift File.join(Dir.pwd, 'lib')

# aggregate = Aggregate.new
loc = Locale.new 'locale/locale.yml'
page = Download.new loc.download.url
page.local_file_hrefs
page.download download.links[0]
page.read_all_zips do |data|
  xml = ParseXML.new data
end
