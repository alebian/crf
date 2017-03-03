require 'spec_helper'

describe Crf::Logger do
  let!(:logger) { described_class.new(LOGGER_PATH) }

  it 'creates the logger' do
    expect(File.exist?(LOGGER_PATH)).to be_truthy
  end

  it 'writes to the logger' do
    msg = 'test'
    size = 34 + msg.size
    expect { logger.write(msg) }.to change { File.size(LOGGER_PATH) }.by size
  end
end
