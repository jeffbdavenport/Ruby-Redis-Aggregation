require 'digest'
module Aggregate
  # Insert data into redis
  class ManageData
    attr_reader :data, :md5_sum, :list
    def initialize(args)
      Arguments.valid? args: args, valid: [:file, :data, :redis, :list]
      @data = args[:data]
      @data ||= File.read args[:file]
      @redis = args[:redis]
      @md5_sum = Digest::MD5.new.update @data
      @list = args[:list] || CONF.redis.list
    end

    # Add data to redis list
    def add_to_list
      return if exists?
      puts LOC.en.manage_data.added % { list: @list, data: @md5_sum }
      @redis.lpush(@list, @data)
      @redis.sadd(md5_list, @md5_sum)
    end

    # Check if sum is in set
    def exists?
      @redis.sismember(md5_list, @md5_sum)
    end

    # MD5 redis set name
    def md5_list
      @list + '_MD5'
    end

    # Remove the data from list and the md5 from the md5 list
    def remove
      @redis.srem(md5_list, @md5_sum)
      @redis.lrem(@list, -1, @data)
    end
  end
end
