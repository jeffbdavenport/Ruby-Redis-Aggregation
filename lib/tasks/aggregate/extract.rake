namespace :aggregate do
  task :extract, [:file] => ['extract:one']

  namespace :extract do
    @file_list = Aggregate::FileList.new entry_path: 'tmp/xml'

    desc 'Extract one file'
    task :one, [:file] do |_, params|
      @file_list.extract File.basename(params[:file])
      puts "Extracted #{@file_list.extracted} files."
    end

    desc 'Extract all files'
    task :all do
      @file_list.extract_all
      puts "Extracted #{@file_list.extracted} files."
    end
  end
end
