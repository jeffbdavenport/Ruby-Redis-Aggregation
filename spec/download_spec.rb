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
    expect(@download.links.size > 20).to be(true)
    expect(@download.links[0] =~ /\A[0-9]{13}\.zip\z/).to be(0)
  end
  describe '.download' do
    it 'should save 1483718331541.zip' do
      file = File.join(@loc.download.path, @download.links[0])
      expect(File.exist?(file)).to be(true)
    end
  end
end
