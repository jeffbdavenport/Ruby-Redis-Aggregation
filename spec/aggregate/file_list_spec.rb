require 'fileutils'
# Access constants in Aggregate
module Aggregate
  RSpec.describe FileList do # rubocop:disable Metrics/BlockLength
    let(:file_list) do
      FileList.new path: 'spec/tmp', entry_path: 'spec/tmp/xml'
    end
    let(:zip) { 'spec/tmp/zip_file.zip' }

    describe '#entry_path' do
      context 'after instantiation' do
        subject { file_list.entry_path }

        context 'with :entry_path' do
          it { is_expected.to eq 'spec/tmp/xml' }
        end

        context 'without :entry_path' do
          let(:file_list) { FileList.new }
          it { is_expected.to eq File.join('tmp', 'entries') }
        end
      end
    end

    describe '#path' do
      context 'after instatiation' do
        subject { file_list.path }

        context 'with :path' do
          it { is_expected.to eq 'spec/tmp' }
        end

        context 'without :path' do
          let(:file_list) { FileList.new }
          it { is_expected.to eq 'tmp' }
        end
      end
    end

    describe '#files' do
      subject { file_list.files }

      it 'is an Array of TmpFile objects' do
        expect(subject.map(&:class).uniq).to eq([TmpFile])
      end

      context 'first element' do
        let(:path) { 'spec/tmp/file' }
        before { FileUtils.rm path if File.exist?(path) }
        specify do
          expect(subject[0].file).to eq 'zip_file.zip'
        end
      end
    end

    describe '#extract' do
      let(:file) { TmpFile.new file: 'zip_file.zip', path: 'spec/tmp' }
      before do
        FileUtils.cp zip, zip + '.bak'
      end
      it 'should extract a file' do
        path = 'spec/tmp/xml/file'
        FileUtils.rm path if File.exist?(path)
        file_list.extract file
        expect(file_list.entry_files[0].file).to eq 'file'
      end
      after do
        FileUtils.mv zip + '.bak', zip
      end
    end

    describe '#read_entries' do
      let(:file) { TmpFile.new file: 'zip_file.zip', path: 'spec/tmp' }
      before do
        FileUtils.cp zip, zip + '.bak'
      end
      it 'should read each file from the zip archive and send it to the block' do
        read_file = false
        file_list.read_entries file do |data|
          read_file = true if !data.nil? && data.chomp == "'test'"
        end
        expect(read_file).to be(true)
      end
      after do
        FileUtils.mv zip + '.bak', zip
      end
    end
  end
end
