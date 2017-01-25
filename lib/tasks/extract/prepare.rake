namespace :extract do
  # Does not need to be run directly
  task :prepare do
    @file_list = Aggregate::FileList.new path: @path, entry_path: @entry_path
  end
end
