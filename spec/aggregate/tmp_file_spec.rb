# Access constants in Aggregate
module Aggregate
  RSpec.describe TmpFile do
    context 'when removing files' do
      subject { File.exist?(file.path) }
      before { FileUtils.touch file.path }

      describe '#rm' do
        before { file.rm }
        it_behaves_like 'the file was removed', 'file'
      end
    end
  end
end
