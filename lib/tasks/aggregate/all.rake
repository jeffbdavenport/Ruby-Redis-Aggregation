namespace :aggregate do
  xml_path = File.join 'tmp', 'xml'

  desc 'For each zip: Download, push to Redis, Delete'
  task :all, [:url] => ['tmp', xml_path, 'extract:prepare'] do |_, params|
    params.with_defaults url: CONF.download.url

    Signal.trap('INT') { Aggregate.kill }
    Signal.trap('TERM') { Aggregate.kill }

    # Aggregate existing zip files
    @file_list.read_all do |data|
      Aggregate::ManageData.aggregate(data)
    end
    @page = Aggregate::Download.new url: params[:url]

    # Download all files, read zip entries, and push to redis
    puts "Aggregating files from #{params[:url]}"
    @page.download_all do |file|
      @file_list.read_entries(file) do |data|
        Aggregate::ManageData.aggregate(data, file.file.chomp('.zip'))
      end
    end
  end
end
