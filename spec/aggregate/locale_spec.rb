# Access constants in Aggregate
module Aggregate
  RSpec.describe Locale do
    let(:locale) { Locale.new file: 'spec/test.yml' }
    it 'should define hash keys as methods' do
      expect(locale.en.hello).to eq 'Hello'
    end
  end
end
