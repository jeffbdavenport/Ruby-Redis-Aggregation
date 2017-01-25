namespace :aggregate do
  desc 'Download, Aggregate, Remove [count] archives   - only downloaded archives'
  task :count, [:count, :url] => [@entry_path, :prepare] do |_, params|
  end
end
