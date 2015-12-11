require 'spec_helper'

describe 'Crf Finder' do
  describe 'creating log file' do
    let!(:logger) { Crf::Logger.new('./spec/test_files/crf.log') }

    before :all do
      File.delete('./spec/test_files/crf.log') if File.exist?('./spec/test_files/crf.log')
    end

    it 'creates the logger' do
      expect(File.exist?('./spec/test_files/crf.log')).to be_truthy
    end
  end
end
