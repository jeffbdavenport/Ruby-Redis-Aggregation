# Access constants in Aggregate
module Aggregate
  RSpec.describe Download do # rubocop:disable Metrics/BlockLength
    let(:download) do
      Download.new(url: CONF.download.url, path: CONF.download.path)
    end
    let!(:count) { download.links.count }

    describe '#links' do
      subject { download.links(argument).count }

      context 'with :all argument' do
        let(:argument) { :all }
        it { is_expected.to be > count }
      end

      context 'with :local argument' do
        let(:argument) { :local }
        it { is_expected.to eq count }
      end
    end

    describe '#download' do
      let(:file_list) do
        FileList.new path:       CONF.file_list.path,
                     entry_path: CONF.file_list.entry_path
      end

      before do
        file_list.rm download.links[0]
      end

      it 'should download', slow: true do
        download.download download.links[0]
        file = File.join(CONF.download.path, download.links[0])
        expect(File.exist?(file)).to be(true)
      end

      after do
        file_list.rm download.links[0]
      end
    end

    describe '#download_one' do
      let(:download) do
        Download.new(url: CONF.download.url, path: CONF.download.path)
      end

      it 'should download one file', slow: true do
        download.download_one
        expect(download.downloaded).to eq 1
      end
    end
  end
end
