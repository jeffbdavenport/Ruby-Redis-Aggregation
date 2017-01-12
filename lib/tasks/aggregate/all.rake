namespace :aggregate do
  desc 'Download, Extract, and insert into Redis'
  task all: ['extract:get_then_all'] do
    @file_list.entry_files.each do |file|
      path = File.join(@entry_path, File.basename(file))
      @manage = Aggregate::ManageData.new file: path, redis: @redis
      @manage.add_to_list
    end
  end
end
