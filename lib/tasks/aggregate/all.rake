namespace :aggregate do
  desc 'Download, Extract, and insert into Redis, does not include file removal'
  task :all do
    @file_list.entry_files.each do |file|
      path = File.join(@entry_path, File.basename(file))
      @manage = Aggregate::ManageData.new file: path, redis: @redis
      @manage.add_to_list
    end
  end
end
