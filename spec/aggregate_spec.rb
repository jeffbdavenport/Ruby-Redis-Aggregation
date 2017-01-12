# Access constants in Aggregate
module Aggregate
  RSpec.describe Aggregate do
    it 'should have Constants defined' do
      [Arguments, Download, FileList, Locale, ManageData, LOC, CONF].each do |const|
        expect(const.nil?).to be false
      end
    end
    it 'should append $LOAD_PATH' do
      lib_path = File.join(Dir.pwd, 'lib')
      expect($LOAD_PATH.include?(Dir.pwd)).to be true
      expect($LOAD_PATH.include?(lib_path)).to be true
    end
  end
end
