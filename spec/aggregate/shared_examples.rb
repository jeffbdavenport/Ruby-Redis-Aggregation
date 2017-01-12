RSpec.shared_examples 'the file was removed' do |file|
  let(:file) { file }
  it { is_expected.to eq false }
end
RSpec.shared_examples 'it raises an error' do |error|
  let(:error) { error }

  it 'should raise error' do
    expect { subject }.to raise_error(error)
  end
end
