require 'spec_helper'

describe Crf::InteractiveFinder do
  before do
    FileUtils.rm_rf(ROOT_TEST_DIRECTORY) if File.exist?(ROOT_TEST_DIRECTORY)
  end

  before do
    create_test_files
  end

  after do
    delete_logger
  end

  context 'when using regular finder' do
    subject(:finder) { described_class.new([ROOT_TEST_DIRECTORY]) }

    it 'search checkes all the files' do
      finder.search_repeated_files
      expect(finder.files.size).to eq(FILE_PATHS.size)
    end

    it 'finds the repetitions with the progress bar' do
      expect(finder.search_repeated_files.empty?).to be_falsey
    end

    it 'finds the correct repetitions with the progress bar' do
      repetitions = finder.search_repeated_files
      expect(repetitions.length).to eq(1)
      repetitions = repetitions.values.first
      expect(repetitions).not_to include(FILE_PATHS[0], FILE_PATHS[5])
      expect(repetitions).to include(FILE_PATHS[1], FILE_PATHS[2], FILE_PATHS[3], FILE_PATHS[4])
    end
  end

  context 'when using fast finder' do
    subject(:finder) { described_class.new([ROOT_TEST_DIRECTORY], true) }

    it 'search checkes all the files' do
      finder.search_repeated_files
      expect(finder.files.size).to eq(FILE_PATHS.size)
    end

    it 'finds size repetitions' do
      expect(finder.search_repeated_files.values.first.count).to eq(FILE_PATHS.size)
    end
  end
end
