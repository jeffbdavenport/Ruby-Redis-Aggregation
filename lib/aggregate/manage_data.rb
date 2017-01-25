require 'digest'
require 'snappy'

module Aggregate
  # Manage redis data
  class ManageData
    attr_reader :md5_sum, :list
    def initialize(args)
      Arguments.valid? args, :file, :data, :list, :redis, :extra
      Arguments.fill args, CONF.redis, :list
      self.data = args[:data]  || File.read(args[:file])
      @redis    = args[:redis] || REDIS
      @list     = args[:list]
      @extra    = '_' + args[:extra] if args[:extra]
    end

    def self.aggregate(data, extra = nil)
      ManageData.new(data: data, extra: extra).add_to_list
    end

    # Get the extra bit from the list
    def self.extra(key, list = CONF.redis.list)
      key.gsub(/#{list}_/, '')
    end

    # add_to_list alias
    def lpush
      add_to_list
    end

    # Add data to redis list
    def add_to_list
      return if exists?
      @redis.lpush list, @data
      sadd
    end

    # Get list of data keys
    def keys
      @redis.keys(@list + '*').reject { |s| s.end_with? '_MD5' }
    end

    def list
      "#{@list}#{@extra}"
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
      @redis.lrem list, -1, @data if exists?
      @redis.srem md5_list, @md5_sum
    end

    # Uncompress data
    def data
      Snappy.inflate @data
    end

    def data=(data)
      @md5_sum = Digest::MD5.new.update(data.to_s).to_s

      # Compress with google's speedy compressor
      @data = Snappy.deflate(data.to_s)
      raise ':data cannot be empty.' if @data.empty?
    end
  end
end
