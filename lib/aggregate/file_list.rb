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
      @files = base_files @path
    end

    # Get array of entry files
    def entry_files
      @entry_files = base_files @entry_path
    end

    # Yield each entry in zip file to a block
    def entries(file)
      return [] unless file.exist?
      return [] if file.zero?
      case file.extname
      when '.zip'
        # Gets array of file entries
        Zip::File.open file.path
      else
        []
      end
    end

    # Extract zip file
    def extract(file)
      puts format LOC.en.file_list.extracting, file: file.path, path: @entry_path
      archive = entries(file)
      archive.each do |entry|
        dest_file = File.join(@entry_path, entry.name)
        next if File.exist?(dest_file)
        entry.extract(dest_file)
        @extracted += 1
      end
      file.rm if archive.count.positive?
    end

    # Extract all zip files
    def extract_all
      files.each do |file|
        extract file
      end
    end

    # Read each zip file and send it to block
    def read_entries(file)
      archive = entries(file)
      entries(file).each do |entry|
        yield(entry.get_input_stream.read)
      end
      return unless archive.count.positive?
      puts format LOC.en.file_list.finished_reading, file: file.path
      file.rm
    end

    # Read each zip
    def read_all
      files.each do |file|
        read_entries file do |data|
          yield(data)
        end
      end
    end

    # remove part files
    def stop_and_remove_parts
      (Thread.list - [Thread.current]).each(&:exit)
      files.each(&:rm_part)
    end

    private

    # Set base path to list of files
    def base_files(path)
      Dir.glob("#{path}/*").map do |f|
        TmpFile.new file: File.basename(f), path: path if File.file?(f)
      end.compact
    end
  end
end
