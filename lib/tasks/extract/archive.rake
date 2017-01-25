namespace :extract do
  desc 'Existing [zip_file] - removes archive'
  task :archive, [:zip_file] => [@entry_path, :prepare] do |_, params|
    RakeHelper.check_params(params, :zip_filex)
    file = Aggregate::TmpFile.new file: params[:zip_file]
    raise "#{file.path} does not exist" unless File.exist? file.path
    @file_list.extract file
    puts "Extracted #{@file_list.extracted} files."
  end
end
