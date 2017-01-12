require_relative '../lib/aggregate'
require_relative 'aggregate/shared_examples'
RSpec.configure do |conf|
  conf.default_path = Dir.pwd

  conf.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
