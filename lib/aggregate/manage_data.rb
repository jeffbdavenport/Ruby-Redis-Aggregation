require 'digest'
module Aggregate
  # Manage redis data
  class ManageData
    attr_reader :md5_sum, :list
    attr_writer :data
    def initialize(args)
      Arguments.valid? args: args, valid: [:file, :data, :list, :redis]
      self.data = args[:data] || File.read(args[:file])
      @list =  args[:list] || CONF.redis.list
      @redis = args[:redis] || REDIS
    end

    # Add data to redis list
    def add_to_list
      return if exists?
      puts LOC.en.manage_data.added % { list: @list, data: @md5_sum }
      @redis.lpush @list, @data
      sadd
    end

    # Alias
    def lpush
      add_to_list
    end

    # Add the MD5 sum of the data to redis
    def sadd
      @redis.sadd md5_list, @md5_sum
    end

    # Check if sum is in set
    def exists?
      @redis.sismember md5_list, @md5_sum
    end

    # MD5 redis set name
    def md5_list
      @list + '_MD5'
    end

    # Remove the data from list and the md5 from the md5 list
    def remove
      @redis.lrem @list, -1, @data if exists?
      @redis.srem md5_list, @md5_sum
    end

    def data=(data)
      @data = data.to_s
      raise ':data cannot be empty.' if @data.empty?
      @md5_sum = Digest::MD5.new.update @data
    end
  end
end
