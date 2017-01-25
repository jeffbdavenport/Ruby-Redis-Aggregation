namespace :aggregate do
  desc 'Download, Aggregate, Remove specified [archive] - skip download if exists'
  task :archive, [:zip_file] => [@path, @entry_path, :prepare] do |_, params|
    RakeHelper.check_params(params, :zip_file)
  end
end
