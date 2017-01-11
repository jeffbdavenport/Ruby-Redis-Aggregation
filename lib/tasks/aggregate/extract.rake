namespace :aggregate do
  task :extract, [:file] => ['extract:one']

  namespace :extract do
    xml_path = File.join 'tmp', 'xml'
    directory xml_path
    @file_list = Aggregate::FileList.new entry_path: xml_path

    desc 'Extract one file'
    task :one, [:file] => xml_path do |_, params|
      @file_list.extract File.basename(params[:file])
      puts "Extracted #{@file_list.extracted} files."
    end

    desc 'Extract all files'
    task all: xml_path do
      @file_list.extract_all
      puts "Extracted #{@file_list.extracted} files."
    end
  end
end
