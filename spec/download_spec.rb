# frozen_string_literal: true
require 'download.rb'
RSpec.describe Download do
  before do
    @loc = Locale.new file: 'locale/locale.yml'
    @download = Download.new url: @loc.download.url, path: @loc.download.path
    @download.local_file_hrefs
    @download.download @download.links[0]
  end
  it "should create tmp dir if it doesn't exist" do
    expect(File.exist?(@loc.download.path)).to eq(true)
  end
  it 'should create an array of only local links' do
    expect(@download.links.class).to eq(Array)
  end

  describe '.download' do
    it 'should save 1000000000000.zip' do
      file = File.join(@loc.download.path, @download.links[0])
      expect(File.exist?(file)).to be(true)
    end
  end

  describe '.local_file_hrefs' do
    it 'should only store file hrefs without a url' do
      expect(@download.links[0] =~ /\A[0-9]{13}\.zip\z/).to be(0)
    end
  end

  describe '.page_hrefs' do
    before do
      @download.page_hrefs
    end
    it 'should store all hrefs' do
      expect(@download.links[0] !~ /\A[0-9]{13}\.zip\z/).to be(0)
    end
  end

  describe '.read_zip' do
    before do
      @read_file = false
      @download.read_zip @download.links[0] do |data|
        @read_file = true unless data.nil?
      end
    end
    it 'should read each file from the zip archive and send it the block' do
      expect(@read_file).to be(true)
    end
  end
end
