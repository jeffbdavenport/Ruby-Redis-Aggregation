require 'lib/aggregate'
Dir.glob('lib/tasks/*/*.rake').each { |rake_file| import rake_file }

task default: ['aggregation:full']

# Variables and methods for all tasks
