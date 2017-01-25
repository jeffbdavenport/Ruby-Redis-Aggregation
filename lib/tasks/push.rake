namespace :push do
  @redis     = Redis.new host: CONF.redis.host, port: CONF.redis.port, db: CONF.redis.db
  @file_list = Aggregate::FileList.new path: @path, entry_path: @entry_path
end

# desc 'Insert XML data into redis'
