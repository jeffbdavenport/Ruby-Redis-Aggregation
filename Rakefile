$LOAD_PATH.unshift File.dirname(__FILE__)
require 'lib/aggregate'
%w(*.rake */*.rake).each do |path|
  Dir.glob("lib/tasks/#{path}").each { |rake_file| import rake_file }
end
Signal.trap('INT') { Aggregate.kill }
Signal.trap('TERM') { Aggregate.kill }

CONF  = Aggregate::CONF
LOC   = Aggregate::LOC

@entry_path = CONF.file_list.entry_path
@path       = CONF.file_list.path

directory @entry_path
directory @path

task default: ['a:info']
task info: ['a:info']
namespace :a do
  desc 'Run `rake` first to get general info about tasks'
  task :info do
    puts RakeHelper.info
  end
end

# Namespace default tasks

desc 'Download, Aggregate, Remove all'
task :aggregate, [:url] => ['aggregate:all']

desc 'All from url'
task :download, [:url] => ['download:all']

desc 'All existing        - removes archives'
task extract: ['extract:all']

desc 'All xmls and zips'
task remove: ['remove:all']

desc 'Run all'
task test: ['test:all']