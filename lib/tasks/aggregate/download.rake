namespace :aggregate do
  desc 'Download zip files'
  task :download, [:url] do |_, params|
    require 'download.rb'
    params.with_defaults url: @loc.download.url
    @page = Download.new url: params[:url]
    @page.local_file_hrefs
    @page.download @page.links[0]
  end
end
