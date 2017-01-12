$LOAD_PATH.unshift File.dirname(__FILE__)
$LOAD_PATH.unshift Dir.pwd
$LOAD_PATH.unshift File.join(Dir.pwd, 'lib')
$LOAD_PATH.uniq!

autoload :Redis, 'redis'

# Autoload each class for the module and add default paths to load path
module Aggregate
  autoload :Arguments, 'aggregate/arguments'
  autoload :Download, 'aggregate/download'
  autoload :FileList, 'aggregate/file_list'
  autoload :Locale, 'aggregate/locale'
  autoload :ManageData, 'aggregate/manage_data'

  # Use locale throughout module
  LOC ||= Locale.new file: 'config/locale/locale.yml'
  CONF ||= Locale.new file: 'config/config.yml'
end
