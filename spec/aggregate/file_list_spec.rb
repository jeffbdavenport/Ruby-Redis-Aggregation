require 'fileutils'
# Access constants in Aggregate
module Aggregate
  RSpec.describe FileList do
    before do
      @file_list = FileList.new path: 'spec/tmp',
                                entry_path: 'spec/tmp/xml'
    end
    describe '#entry_path' do
      before { @file_list = FileList.new }
      it 'should be tmp/entries' do
        expect(@file_list.entry_path).to eq File.join('tmp', 'entries')
      end
    end

    describe '#path' do
      before { @file_list = FileList.new }
      it 'should be tmp' do
        expect(@file_list.path).to eq 'tmp'
      end
    end

    describe '#files' do
      before do
        @file_list.rm_entry 'file'
      end
      it "should be ['file']" do
        expect(@file_list.files[0]).to eq 'zip_file.zip'
      end
    end

    describe '#rm_entry' do
      file_path = 'spec/tmp/xml/file'
      before do
        FileUtils.touch file_path
        @file_list.rm_entry 'file'
      end
      it 'should remove a file' do
        expect(File.exist?(file_path)).to eq false
      end
    end

    describe '#rm' do
      file_path = 'spec/tmp/file'
      before do
        FileUtils.touch file_path
        @file_list.rm 'file'
      end
      it 'should remove a file' do
        expect(File.exist?(file_path)).to eq false
      end
    end

    describe '#extract' do
      before do
        @file_list.rm_entry 'file'
        @file_list.extract @file_list.files[0]
      end
      it 'should extract a file' do
        expect(@file_list.entry_files[0]).to eq 'file'
      end
    end

    describe '#read_entries' do
      before do
        @read_file = false
        @file_list.read_entries @file_list.files[0] do |data|
          @read_file = true unless data.nil?
        end
      end
      it 'should read each file from the zip archive and send it to the block' do
        expect(@read_file).to be(true)
      end
    end
  end
end
