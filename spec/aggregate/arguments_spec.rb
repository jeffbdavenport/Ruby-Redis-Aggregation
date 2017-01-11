# Access constants in Aggregate
module Aggregate
  RSpec.describe Arguments do
    describe '.valid?' do
      describe 'raises exception' do
        it 'HashOnly when arguments is not a hash' do
          expect do
            Arguments.valid? args: 'string', valid: :fail
          end.to raise_error(Arguments::HashOnly)
        end
        it 'InvalidKey when arguments is not a hash' do
          expect do
            Arguments.valid? args: { test: 'test' }, valid: :fail
          end.to raise_error(Arguments::InvalidKey)
        end
        it 'MustHaveArgs when valid? argsument is missing :args key' do
          expect do
            Arguments.valid?(valid: :test)
          end.to raise_error(Arguments::MustHaveArgs)
        end
      end

      it 'should return true, if it has valid arguments' do
        expect(
          Arguments.valid?(args: { test: 'test' }, valid: :test)
        ).to be true
      end
      it 'should return true, if it is missing valid key' do
        expect(
          Arguments.valid?(args: { test: 'test' })
        ).to be true
      end
    end
  end
end
