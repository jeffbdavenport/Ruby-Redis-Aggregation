namespace :download do
  desc 'Only specified archive'
  task :archive, [:zip_file, :url] => [:prepare] do |_, params|
    RakeHelper.check_params(params, :zip_file)
    file = Aggregate::TmpFile.new file: params[:zip_file]
    warn "#{file.file} exists or is already aggregated" unless file.download?
    @page.download file
    puts 'Complete'
  end
end
