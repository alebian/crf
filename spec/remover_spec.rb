require 'spec_helper'
require 'crf/logger'

describe Crf::Remover do
  let(:finder) { Crf::Finder.new(FILE_DIRECTORIES) }
  let(:logger) { Crf::Logger.new("#{ROOT_TEST_DIRECTORY}/crf.log") }

  before :each do
    create_test_files
  end

  it 'finds the repetitions and removes them' do
    finder.search_repeated_files
    described_class.new(finder.repetitions, logger).remove
    finder.search_repeated_files
    expect(finder.paths.size).to eq(3)
    expect(finder.repetitions.empty?).to be_truthy
    expect(finder.repetitions.length).to eq(0)
  end

  context 'when there are no files' do
    subject(:remover) { described_class.new({ 'null' => [path, path] }, logger) }
    let(:path) { "#{ROOT_TEST_DIRECTORY}/marta" }

    it 'does not remove files' do
      expect(remover.remove).to be 0
    end
  end
end
