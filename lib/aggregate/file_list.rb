require 'zip'

module Aggregate
  # Downloads files from url
  class FileList
    attr_reader :files
    def initialize(args)
      @path = args[:path] ||= 'tmp'
      Dir.mkdir @path unless File.exist?(@path)
      @url = args[:url]
    end

    # Yield each entry in zip file to a block
    def zip_entries(file)
      return unless File.extname(file) == '.zip'
      Zip::File.open(File.join(@path, file)) do |zip_file|
        zip_file.each do |entry|
          yield(entry)
        end
      end
    end

    # Extract zip file
    def extract_zip(file)
      zip_entries(file) do |entry|
        dest_file = File.join(@path, entry.name)
        entry.extract(dest_file)
      end
    end

    # read each zip file and send it to block
    def read_zip(file)
      zip_entries(file) do |entry|
        yield(entry.get_input_stream.read)
      end
    end

    # Extract all zip files
    def extract_all_zips
      @links.each do |link|
        yield(extract_zip link)
      end
    end

    # read each zip
    def read_all_zips
      @links.each do |link|
        yield(read_zip link)
      end
    end
  end
end