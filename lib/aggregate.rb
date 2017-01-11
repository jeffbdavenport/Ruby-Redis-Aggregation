$LOAD_PATH.unshift File.dirname(__FILE__)
$LOAD_PATH.unshift Dir.pwd
$LOAD_PATH.unshift File.join(Dir.pwd, 'lib')
$LOAD_PATH.uniq!
# Autoload each class for the module and add default paths to load path
module Aggregate
  autoload :Arguments, 'aggregate/arguments'
  autoload :Download, 'aggregate/download'
  autoload :FileList, 'aggregate/file_list'
  autoload :Locale, 'aggregate/locale'
  autoload :ParseXML, 'aggregate/parse_xml'

  # Use locale throughout module
  LOC ||= Locale.new file: 'config/locale/locale.yml'
end
