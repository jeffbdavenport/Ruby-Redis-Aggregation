# frozen_string_literal: true
require 'locale.rb'
RSpec.describe Locale do
  before do
    @locale = Locale.new file: 'spec/test.yml'
  end

  it 'should define hash keys as methods' do
    expect(@locale.en.hello).to eq('Hello')
  end
end
