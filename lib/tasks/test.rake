task test: ['test:fast']

namespace :test do
  begin
    require 'rspec/core/rake_task'

    desc 'Run only fast tests'
    RSpec::Core::RakeTask.new(:fast) do |t|
      t.rspec_opts = '--tag ~slow'
    end

    desc 'Run only slow tests'
    RSpec::Core::RakeTask.new(:slow) do |t|
      t.rspec_opts = '--tag slow'
    end

  rescue LoadError
    puts 'Could not load rspec'
  end
end
