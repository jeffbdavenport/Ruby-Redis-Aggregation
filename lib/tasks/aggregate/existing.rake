namespace :aggregate do
  desc 'All existing        - no download'
  task :existing do
    @file_list.aggregate_all
  end
end
