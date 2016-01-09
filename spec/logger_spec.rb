require 'spec_helper'

describe 'Crf Finder' do
  context 'when creating log file' do
    let!(:logger_path) { './spec/crf.log' }
    let!(:logger) { Crf::Logger.new(logger_path) }

    it 'creates the logger' do
      expect(File.exist?(logger_path)).to be_truthy
    end
    it 'writes to the logger' do
      msg = 'test'
      size = 34 + msg.size
      expect { logger.write(msg) }.to change { File.size(logger_path) }.by size
    end
  end
end
