namespace :aggregate do
  desc 'Existing [xml_file]'
  task :file, [:xml_file] => [@path, @entry_path, :prepare] do |_, params|
    RakeHelper.check_params(params, :xml_file)
  end
end
