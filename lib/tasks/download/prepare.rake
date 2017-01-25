namespace :download do
  # Prepare @page for tasks
  # Task does not need to be run directly
  task :prepare, [:url] => @path do |_, params|
    @page = Aggregate::Download.new url: params[:url]
  end
end
