namespace :aggregate do
  # Does not need to be run directly
  task :prepare, [:url] => [@path, @entry_path] do |_, params|
    params.with_defaults url: CONF.download.url
    @page = Aggregate::Download.new url: params[:url]
  end
end
