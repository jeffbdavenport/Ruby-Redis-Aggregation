$LOAD_PATH.unshift File.dirname(__FILE__)
require 'lib/aggregate'
%w(*.rake */*.rake).each do |path|
  Dir.glob("lib/tasks/#{path}").each { |rake_file| import rake_file }
end

task default: ['aggregate:full']