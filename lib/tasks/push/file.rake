namespace :push do
  desc 'Existing [xml_file]'
  task :file, [:xml_file] => [@archive_path, @xml_path, 'extract:prepare'] do |_, params|
    RakeHelper.check_params(params, :xml_file)
  end
end
