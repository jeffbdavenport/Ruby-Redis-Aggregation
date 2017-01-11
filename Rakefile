$LOAD_PATH.unshift Dir.pwd
$LOAD_PATH.unshift File.join(Dir.pwd, 'lib')
require 'locale.rb'
Dir.glob('lib/tasks/*/*.rake').each { |r| import r }
@loc = Locale.new file: 'config/locale/locale.yml'
task default: ['aggregation:full']
