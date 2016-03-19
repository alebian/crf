require 'spec_helper'
require 'crf/logger'

describe 'Crf Remover' do
  context 'when deleting files' do
    let!(:finder) { Crf::Finder.new(FILE_DIRECTORIES.first) }
    let!(:logger) { Crf::Logger.new("#{FILE_DIRECTORIES.first}/crf.log") }

    before :each do
      create_test_files
    end

    it 'finds the repetitions and removes them' do
      finder.search_repeated_files
      Crf::Remover.new(finder.repetitions, logger).remove
      finder.search_repeated_files
      expect(finder.paths.size).to eq(3)
      expect(finder.repetitions.empty?).to be_truthy
    end

    it 'does not remove unique files' do
      finder.search_repeated_files
      Crf::Remover.new(finder.repetitions, logger).remove
      finder.search_repeated_files
      expect(finder.repetitions.length).to eq(0)
    end

    it 'does not remove unexisting files' do
      path = "#{FILE_DIRECTORIES.first}/marta"
      remover = Crf::Remover.new({ 'null' => [path, path] }, logger)
      expect(remover.remove).to be 0
    end
  end
end
