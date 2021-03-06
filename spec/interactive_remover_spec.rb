require 'spec_helper'
require 'crf/logger'
require 'stringio'

describe Crf::InteractiveRemover do
  let(:finder) { Crf::Finder.new(FILE_DIRECTORIES) }
  let(:logger) { Crf::Logger.new("#{ROOT_TEST_DIRECTORY}/crf.log") }

  before :each do
    create_test_files
  end

  it 'finds the repetitions and removes them' do
    finder.search_repeated_files
    $stdin = StringIO.new("n\ny\ny\ny\n")
    described_class.new(finder.repetitions, logger).remove
    finder.search_repeated_files
    expect(finder.paths.size).to eq(3)
    expect(finder.repetitions.empty?).to be_truthy
    $stdin = STDIN
  end

  it 'does not remove unique files' do
    finder.search_repeated_files
    $stdin = StringIO.new("n\ny\ny\ny\n")
    described_class.new(finder.repetitions, logger).remove
    finder.search_repeated_files
    expect(finder.repetitions.length).to eq(0)
    $stdin = STDIN
  end

  it 'does not remove unexisting files' do
    path = "#{ROOT_TEST_DIRECTORY}/marta"
    remover = described_class.new({ 'null' => [path, path] }, logger)
    $stdin = StringIO.new("n\nn\n")
    expect(remover.remove).to be 0
    $stdin = STDIN
  end
end
