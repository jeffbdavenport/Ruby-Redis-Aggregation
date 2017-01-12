namespace :extract do
  xml_path = File.join 'tmp', 'xml'
  directory xml_path

  # Extract one file
  task :one, [:file] => [xml_path, :prepare] do |_, params|
    @file_list.extract File.basename(params[:file])
    puts "Extracted #{@file_list.extracted} files."
  end

  desc 'Extract all files'
  task all: [xml_path, :prepare] do
    @file_list.extract_all
    puts "Extracted #{@file_list.extracted} files."
  end

  desc 'Download one and, Extract all files'
  task get_then_all: [xml_path, :prepare, 'download:one'] do
    @file_list.extract_all
    puts "Extracted #{@file_list.extracted} files."
  end

  # Does not need to be run directly
  task :prepare do
    @file_list = Aggregate::FileList.new path: 'tmp', entry_path: xml_path
  end
end

desc 'Extract one file'
task :extract, [:file] => ['extract:one']
