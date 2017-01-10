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
  it 'should create an array of only local links' do
    expect(@download.links.class).to eq(Array)
    expect(@download.links[0]).to be('1483718331541.zip')
  end
  describe 'download' do
    it 'should download 1483718331541.zip'
      expect(File.exist?(File.join(@loc.download.path, '1483718331541.zip'))).to be(true)
    end
  end
end
