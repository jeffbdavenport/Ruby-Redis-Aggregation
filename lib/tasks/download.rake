desc 'Download one zip file'
task :download, [:url] => ['download:one']

namespace :download do
  directory 'tmp'

  # Download one zip file
  task :one, [:url] => [:prepare] do
    @page.download_one
    puts 'Complete'
  end

  desc 'Download all files'
  task :all, [:url] => [:prepare] do
    @page.download_all
    puts 'Complete'
  end

  # Prepare @page for tasks
  # Task does not need to be run directly
  task :prepare, [:url] => 'tmp' do |_, params|
    params.with_defaults url: CONF.download.url
    @page = Aggregate::Download.new url: params[:url]
    @page.local_file_hrefs
  end
end
