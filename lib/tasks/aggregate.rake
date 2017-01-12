require 'redis'

desc 'Download, Extract, and insert into Redis, does not include file removal'
task :aggregate, [:file] do |_, params|
  path = File.join(@entry_path, File.basename(params[:file]))
  @manage = Aggregate::ManageData.new file: path, redis: @redis
  @manage.add_to_list
end

namespace :aggregate do
  @redis = Redis.new host: CONF.redis.host, port: CONF.redis.port, db: CONF.redis.db
  @file_list = FileList.new path: @path, entry_path: @entry_path
  @entry_path = CONF.file_list.entry_path
  @path = CONF.file_list.path
end

# desc 'Insert XML data into redis'
