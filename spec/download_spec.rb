# frozen_string_literal: true
require 'download.rb'
RSpec.describe Download do
  before do
    @loc = Locale.new file: 'locale/locale.yml'
    @download = Download.new url: @loc.download.url, path: @loc.download.path
  end
  it "should create tmp dir if it doesn't exist" do
    expect(File.exist?(@loc.download.path)).to eq(true)
  end
  it 'should create an array of links' do
    expect(@download.links.class).to eq(Array)
  end
end
