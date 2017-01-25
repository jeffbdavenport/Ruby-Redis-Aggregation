# Access constants in Aggregate
module Aggregate
  RSpec.describe Arguments do
    describe '.valid?' do
      subject { Arguments.valid?(*arguments) }

      context 'when not a hash' do
        let(:arguments) { ['string', :fail] }
        it_behaves_like 'it raises error'
      end

      context 'when key is invalid' do
        let(:arguments) { [{ test: 'test' }, :fail] }
        it_behaves_like 'it raises error'
      end

      context 'when missing :args key' do
        let(:arguments) do
          { valid: :test }
        end
        it_behaves_like 'it raises error'
      end

      context 'when valid' do
        let(:arguments) { [{ test: 'test' }, :test] }
        it { is_expected.to be true }
      end

      context 'when missing :valid key' do
        let(:arguments) { [{ test: 'test' }] }
        it { is_expected.to be true }
      end
    end
  end
end
