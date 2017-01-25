autoload :Redis, 'redis'
autoload :RakeHelper, 'rake_helper'

$LOAD_PATH.unshift File.dirname(__FILE__)
$LOAD_PATH.unshift Dir.pwd
$LOAD_PATH.unshift File.join(Dir.pwd, 'lib')
$LOAD_PATH.uniq!

# Autoload each class for the module and add default paths to load path
module Aggregate
  autoload :Arguments,  'aggregate/arguments'
  autoload :Download,   'aggregate/download'
  autoload :Locale,     'aggregate/locale'
  autoload :ManageData, 'aggregate/manage_data'

  # Use locale throughout module
  LOC        ||= Locale.new file: 'config/locale/locale.yml'
  CONF       ||= Locale.new file: 'config/config.yml'
  THREAD_MAX ||= 4
  REDIS      ||= Redis.new  host: CONF.redis.host, port: CONF.redis.port,
                            db:   CONF.redis.db

  # Required for signal trap, Cannot call require in signal trap
  # Not at top of file because constants used in constant aliases
  require_relative 'aggregate/file_list'
  require_relative 'aggregate/tmp_file'

  # Stop downloads, remove part files and exit
  def self.kill
    FileList.new.stop_and_remove_parts
    puts # Add blank line for cleanliness
    exit
  end
end
