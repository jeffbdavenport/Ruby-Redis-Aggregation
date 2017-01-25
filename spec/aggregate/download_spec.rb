# Access constants in Aggregate
module Aggregate
  RSpec.describe Download do # rubocop:disable Metrics/BlockLength
    let(:download) { Download.new path: 'spec/tmp' }
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

    context 'when downloading' do
      let(:file_list) { FileList.new path: 'spec/tmp', entry_path: 'spec/tmp/xml' }
      after do
        file_list.files.each do |f|
          f.data.remove
          f.rm if f.file != 'zip_file.zip'
        end
      end

      describe '#download' do
        let(:file) { download.links[0] }

        before do
          file.data.remove
          file.rm
        end

        it 'should download', slow: true do
          download.download file
          expect(File.exist?(file.path)).to be(true)
        end
      end

      describe '#download_one' do
        it 'should download one file', slow: true do
          download.download_one
          expect(download.downloaded).to eq 1
        end
      end
    end
  end
end
