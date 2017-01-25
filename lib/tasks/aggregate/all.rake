namespace :aggregate do
  task :all, [:url] => [:existing, :prepare] do |_, params|
    # Download all files, read zip entries, and push to redis
    puts "Aggregating files from #{params[:url]}"
    @page.download_all do |file|
      @file_list.aggregate(file)
    end
  end
end
