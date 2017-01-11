namespace :aggregate do
  desc 'Download zip files'
  task :download, [:url] do |_, params|
    require 'download.rb'
    params.with_defaults url: Aggregate::LOC.download.url
    @page = Aggregate::Download.new url: params[:url]
    @page.local_file_hrefs
    @page.download @page.links[0]
  end
end
