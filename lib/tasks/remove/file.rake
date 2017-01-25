namespace :remove do
  desc 'Existing [xml_file]'
  # Task will never remove files outside of CONF.file_list.entry_path
  task :file, [:xml_file] => ['extract:prepare'] do |_, params|
    RakeHelper.check_params(params, :xml_file)
    RakeHelper.remove_file params[:xml_file]
  end
end
