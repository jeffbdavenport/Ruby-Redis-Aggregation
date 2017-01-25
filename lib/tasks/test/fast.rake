namespace :test do
  desc 'Fast only'
  RSpec::Core::RakeTask.new(:fast) do |t|
    t.rspec_opts = '--tag ~slow'
  end
end
