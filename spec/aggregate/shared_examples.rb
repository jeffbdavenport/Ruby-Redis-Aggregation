# Access constants in Aggregate
module Aggregate
  RSpec.shared_examples 'the file was removed' do |file|
    let(:file) { TmpFile.new file: file, path: 'spec/tmp' }
    it { is_expected.to eq false }
  end
  RSpec.shared_examples 'it raises error' do
    it 'should raise error' do
      expect { subject }.to raise_error(RuntimeError)
    end
  end
end