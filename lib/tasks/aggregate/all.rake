namespace :aggregate do
  task :all, [:url] => [@path, @entry_path, 'extract:prepare'] do |_, params|
    params.with_defaults url: CONF.download.url

    # Aggregate existing zip files
    @file_list.aggregate_all
    @page = Aggregate::Download.new url: params[:url]

    # Download all files, read zip entries, and push to redis
    puts "Aggregating files from #{params[:url]}"
    @page.download_all do |file|
      @file_list.aggregate(file)
    end
  end
end
