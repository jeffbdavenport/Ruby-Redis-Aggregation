namespace :aggregate do
  xml_path = File.join 'tmp', 'xml'

  desc 'Download, Extract, and insert into Redis'
  task all: [xml_path, 'download:one'] do
    # extract files
    # @file_list.entry_files.each do |file|
    # path = File.join(@entry_path, File.basename(file))
    # end

    # Read without extracting
    @file_list.read_all do |data|
      @manage = Aggregate::ManageData.new data: data, redis: @redis
      @manage.add_to_list
    end
  end
end
