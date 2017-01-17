require 'fileutils'
module Aggregate
  # Add some helper methods to File
  class TmpFile
    attr_reader :file_ext, :file
    def initialize(args)
      Arguments.valid? args: args, valid: [:file, :path]
      @file = args[:file]
      @path = args[:path]
    end

    def self.url
      CONF.download.url
    end

    # Path to file
    def path
      File.join @path, @file.chomp('.part')
    end

    # File URL
    def url
      URI.join TmpFile.url, @file
    end

    # File path with .part
    def part
      "#{path.chomp('.part')}.part"
    end

    # Whether file should be downloaded
    def download?
      File.exist?(path) || data.exists? ? false : true
    end

    # Redis list for file
    def data
      @data ||= ManageData.new data: url.to_s, list: @list
    end

    def extname
      File.extname @file
    end

    def zero?
      File.zero? path
    end

    def exist?
      File.exist? path
    end

    # Remove file from folder
    def rm
      FileUtils.rm path if File.exist?(path)
    end

    # Remove file from folder
    def rm_part
      FileUtils.rm part if File.exist?(part)
    end

    # Add file to redis to prevent re-download
    def add_to_redis(mutex = Mutex.new)
      mutex.synchronize do
        data.sadd
      end
    end

    def save_part
      FileUtils.mv part, path
    end
  end
end
