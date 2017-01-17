# Access constants in Aggregate
module Aggregate
  RSpec.describe Arguments do # rubocop:disable Metrics/BlockLength
    describe '.valid?' do     # rubocop:disable Metrics/BlockLength
      subject { Arguments.valid?(arguments) }

      context 'when not a hash' do
        let(:arguments) do
          { args: 'string', valid: :fail }
        end
        it_behaves_like 'it raises error'
      end

      context 'when key is invalid' do
        let(:arguments) do
          { args: { test: 'test' }, valid: :fail }
        end
        it_behaves_like 'it raises error'
      end

      context 'when missing :args key' do
        let(:arguments) do
          { valid: :test }
        end
        it_behaves_like 'it raises error'
      end

      context 'when valid' do
        let(:arguments) do
          { args: { test: 'test' }, valid: :test }
        end
        it { is_expected.to be true }
      end

      context 'when missing :valid key' do
        let(:arguments) do
          { args: { test: 'test' } }
        end
        it { is_expected.to be true }
      end
    end
  end
end
