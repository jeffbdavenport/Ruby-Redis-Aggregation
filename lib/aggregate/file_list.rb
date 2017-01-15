require 'zip'
require 'fileutils'

module Aggregate
  # Downloads files from url
  class FileList
    attr_reader :entry_path, :path, :extracted
    def initialize(args = {})
      Arguments.valid? args: args, valid: [:entry_path, :path]
      @entry_path = args[:entry_path] || File.join('tmp', 'entries')
      @path = args[:path] || File.join('tmp')
      @extracted = 0
    end

    # Get array of files in @path
    def files
      @files ||= base_files "#{@path}/*"
    end

    # Get array of entry files
    def entry_files
      @entry_files ||= base_files "#{@entry_path}/*"
    end

    # Yield each entry in zip file to a block
    def entries(file)
      case File.extname(file)
      when '.zip'
        # Gets array of file entries
        Zip::File.open(File.join(@path, file))
      end
    end

    # Extract zip file
    def extract(file)
      puts LOC.en.file_list.extracting % {
        file: File.join(@path, file), path: @entry_path
      }
      entries(file).each do |entry|
        dest_file = File.join(@entry_path, entry.name)
        next if File.exist?(dest_file)
        entry.extract(dest_file)
        @extracted += 1
      end
      rm file
    end

    # Extract all zip files
    def extract_all
      files.each do |file|
        extract file
      end
    end

    # Read each zip file and send it to block
    def read_entries(file)
      entries(file).each do |entry|
        yield(entry.get_input_stream.read)
      end
      rm file
    end

    # Read each zip
    def read_all
      files.each do |file|
        read_entries file do |data|
          yield(data)
        end
      end
    end

    # Remove file from folder
    def rm(file)
      rm_file @path, file
    end

    # Remove entry file from folder
    def rm_entry(entry_file)
      rm_file @entry_path, entry_file
    end

    private

    # Remove file if it exists
    def rm_file(path, file)
      return false if file.nil?
      file_path = File.join(path, file)
      files.delete file
      FileUtils.rm file_path if File.exist?(file_path)
      true
    end

    # Set base path to list of files
    def base_files(path)
      Dir.glob(path).map { |f| File.basename(f) if File.file?(f) }.compact
    end
  end
end
