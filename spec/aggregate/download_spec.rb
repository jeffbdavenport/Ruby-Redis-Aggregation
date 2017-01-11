# Access constants in Aggregate
module Aggregate
  RSpec.describe Download do
    before do
      @download = Download.new url: LOC.download.url, path: LOC.download.path
      @download.local_file_hrefs
    end

    describe '#page_hrefs' do
      before do
        @download.page_hrefs
      end
      it 'should create an array of only local links' do
        expect(@download.links.class).to eq(Array)
      end
      it 'should store all hrefs' do
        expect(@download.links.empty?).to be false
      end
    end

    before do
      @download.download @download.links[0]
    end
    describe '#download' do
      before do
        @file_list = FileList.new path: LOC.file_list.path,
                                  entry_path: LOC.file_list.entry_path
        @file_list.rm @download.links[0]
        @download.download @download.links[0]
      end
      it 'should save file.zip' do
        file = File.join(LOC.download.path, @download.links[0])
        expect(File.exist?(file)).to be(true)
      end
    end

    describe '#local_file_hrefs' do
      before { @download.local_file_hrefs }
      it 'should only store file hrefs without a url' do
        expect(@download.links[0] =~ /\A[0-9]{13}\.zip\z/).to be(0)
      end
    end
  end
end
