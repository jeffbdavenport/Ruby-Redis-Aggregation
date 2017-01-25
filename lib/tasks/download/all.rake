namespace :download do
  task :all, [:url] => [:prepare] do
    @page.download_all
    puts 'Complete'
  end
end
