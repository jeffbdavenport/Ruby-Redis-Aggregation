namespace :test do
  desc 'Slow only'
  RSpec::Core::RakeTask.new(:slow) do |t|
    t.rspec_opts = '--tag slow'
  end
end
