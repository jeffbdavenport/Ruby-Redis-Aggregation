namespace :extract do
  task all: [@entry_path, :prepare] do
    @file_list.extract_all
    puts "Extracted #{@file_list.extracted} files."
  end
end
