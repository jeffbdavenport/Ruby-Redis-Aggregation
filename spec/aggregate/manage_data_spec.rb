# Access constants in Aggregate
module Aggregate
  RSpec.describe ManageData do # rubocop:disable Metrics/BlockLength
    let(:redis) { Redis.new }
    let(:data) { ManageData.new data: 'test', redis: redis }

    describe '#data' do
      subject { data.data }
      context 'when instatiated with :data' do
        it { is_expected.to eq 'test' }
      end
      context 'when instantiated with :file' do
        let(:data) do
          ManageData.new file: 'spec/aggregate/manage_data_file', redis: redis
        end
        it { is_expected.to eq 'manage_test_data' }
      end
    end

    describe '#list' do
      subject { data.list }
      it { is_expected.to eq 'NEWS_XML' }
      context 'with instantiated with :list' do
        let(:data) { ManageData.new data: 'test', redis: redis, list: 'TEST' }
        it { is_expected.to eq 'TEST' }
      end
    end
    context 'when getting data from redis' do
      let(:data) { ManageData.new data: 'test', redis: redis, list: 'TEST' }
      subject { data.exists? }

      describe '#exists?' do
        it { is_expected.to eq false }

        context 'after #add_to_list' do
          example do
            data.add_to_list
            is_expected.to eq true
          end
        end

        context 'after #remove' do
          example do
            data.remove
            is_expected.to eq false
          end
        end
      end
    end

    describe '#md5_list' do
      it 'should append _MD5' do
        expect(data.md5_list).to eq 'NEWS_XML_MD5'
      end
    end

    describe '#md5_sum' do
      it 'should return md5sum of data' do
        expect(data.md5_sum).to eq Digest::MD5.new.update('test')
      end
    end
  end
end
