namespace :push do
  desc 'Existing [archive]  - reads zip instead of extract'
  task :archive, [:zip_file] => [@path, @xml_path, 'extract:prepare'] do |_, params|
    RakeHelper.check_params(params, :zip_file)
  end
end
