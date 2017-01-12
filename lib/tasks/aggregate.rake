require 'redis'

desc 'Insert file into Redis, does not include file removal'
task :aggregate, [:file] do |_, params|
  puts @file_list.entry_files[0].to_s
  params.with_defaults file: @file_list.entry_files[0]
  path = File.join(@entry_path, params[:file])
  @manage = Aggregate::ManageData.new file: path, redis: @redis
  @manage.add_to_list
end

namespace :aggregate do
  @entry_path = CONF.file_list.entry_path
  @path = CONF.file_list.path
  @redis = Redis.new host: CONF.redis.host, port: CONF.redis.port, db: CONF.redis.db
  @file_list = Aggregate::FileList.new path: @path, entry_path: @entry_path
end

# desc 'Insert XML data into redis'
