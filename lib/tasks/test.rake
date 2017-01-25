namespace :test do
  begin
    require 'rspec/core/rake_task'
  rescue LoadError
    puts 'Could not load rspec'
  end
end
