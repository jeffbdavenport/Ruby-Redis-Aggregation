$LOAD_PATH.unshift File.dirname(__FILE__)
require 'lib/aggregate'
Dir.glob('lib/tasks/*/*.rake').each { |rake_file| import rake_file }

task default: ['aggregation:full']
