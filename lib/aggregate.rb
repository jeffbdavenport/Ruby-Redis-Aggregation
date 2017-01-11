require 'redis'

# Autoload each class for the module and add default paths to load path
module Aggregate
  $LOAD_PATH.unshift Dir.pwd
  $LOAD_PATH.unshift File.join(Dir.pwd, 'lib')

  autoload :Arguments, 'aggregate/arguments'
  autoload :Locale, 'aggregate/locale'
  autoload :Download, 'aggregate/download'
  autoload :FileList, 'aggregate/file_list'
  autoload :ParseXML, 'aggregate/parse_xml'

  # Use locale throughout module
  LOC = Locale.new file: 'config/locale/locale.yml'
end
