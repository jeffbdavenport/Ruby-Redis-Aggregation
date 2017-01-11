require 'lib/aggregate.rb'
Dir.glob('lib/tasks/*/*.rake').each { |rake_file| import rake_file }

task default: ['aggregation:full']
