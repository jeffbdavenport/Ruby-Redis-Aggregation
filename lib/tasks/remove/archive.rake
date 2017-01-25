namespace :remove do
  desc 'Existing [archive]'
  # Task will only remove files directly inside of CONF.file_list.path
  task :archive, [:zip_file] => ['extract:prepare'] do |_, params|
    RakeHelper.check_params(params, :zip_file)
    RakeHelper.remove_file params[:zip_file]
  end
end
