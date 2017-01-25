namespace :aggregate do
  desc 'Download, Aggregate, Remove existing [archive] - skip download if exists'
  task :archive, [:zip_file] => [@path, @entry_path, 'extract:prepare'] do |_, params|
    RakeHelper.check_params(params, :zip_file)
  end
end
