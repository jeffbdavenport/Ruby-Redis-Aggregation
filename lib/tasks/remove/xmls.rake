namespace :remove do
  desc 'Remove XML files'
  task :xmls do
    RakeHelper.remove_files @file_list.entry_files, 'xml', @file_list.entry_path
  end
end
