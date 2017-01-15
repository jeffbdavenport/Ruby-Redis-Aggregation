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

      it 'is an Array of files in path' do
        is_expected.to eq(
          Dir.glob('spec/tmp/*').map { |f| File.basename(f) if File.file?(f) }.compact
        )
      end

      context 'first element' do
        before { file_list.rm_entry 'file' }
        specify do
          expect(subject[0]).to eq 'zip_file.zip'
        end
      end
    end

    context 'when removing files' do
      subject { File.exist?(file) }
      before { FileUtils.touch file }

      describe '#rm_entry' do
        before { file_list.rm_entry 'file' }
        it_behaves_like 'the file was removed', 'spec/tmp/xml/file'
      end

      describe '#rm' do
        before { file_list.rm 'file' }
        it_behaves_like 'the file was removed', 'spec/tmp/file'
      end
    end
    describe '#extract' do
      before do
        FileUtils.cp zip, zip + '.bak'
      end
      it 'should extract a file' do
        file_list.rm_entry 'file'
        file_list.extract 'zip_file.zip'
        expect(file_list.entry_files[0]).to eq 'file'
      end
      after do
        FileUtils.mv zip + '.bak', zip
      end
    end

    describe '#read_entries' do
      before do
        FileUtils.cp zip, zip + '.bak'
      end
      it 'should read each file from the zip archive and send it to the block' do
        read_file = false
        file_list.read_entries 'zip_file.zip' do |data|
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
