namespace :remove do
  desc 'Remove zip files'
  task :zips do
    RakeHelper.remove_files @file_list.files, 'zip', @file_list.path
  end
end
