namespace :extract do
  xml_path = File.join 'tmp', 'xml'
  directory xml_path
  @file_list = Aggregate::FileList.new path: 'tmp', entry_path: xml_path

  # Extract one file
  task :one, [:file] => xml_path do |_, params|
    @file_list.extract File.basename(params[:file])
    puts "Extracted #{@file_list.extracted} files."
  end

  desc "Extract all files in #{@file_list.path}"
  task all: xml_path do
    @file_list.extract_all
    puts "Extracted #{@file_list.extracted} files."
  end
end

desc "Extract one file to #{@file_list.entry_path}"
task :extract, [:file] => ['extract:one']
