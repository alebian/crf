require 'spec_helper'

describe 'Crf Finder' do
  before do
    FileUtils.rm_rf(ROOT_TEST_DIRECTORY) if File.exist?(ROOT_TEST_DIRECTORY)
  end

  context 'when finding files from single' do
    let!(:finder)                  { Crf::Finder.new([ROOT_TEST_DIRECTORY]) }
    let!(:fast_finder)             { Crf::Finder.new([ROOT_TEST_DIRECTORY], true) }
    let!(:interactive_finder)      { Crf::InteractiveFinder.new([ROOT_TEST_DIRECTORY]) }
    let!(:interactive_fast_finder) { Crf::InteractiveFinder.new([ROOT_TEST_DIRECTORY], true) }

    before do
      create_test_files
    end

    context 'when using all finders' do
      it 'search checkes all the files' do
        delete_logger
        interactive_finder.search_repeated_files
        delete_logger
        finder.search_repeated_files
        delete_logger
        interactive_fast_finder.search_repeated_files
        delete_logger
        fast_finder.search_repeated_files
        expect(interactive_finder.files.size).to eq(FILE_PATHS.size)
        expect(finder.files.size).to eq(FILE_PATHS.size)
        expect(interactive_fast_finder.files.size).to eq(FILE_PATHS.size)
        expect(fast_finder.files.size).to eq(FILE_PATHS.size)
      end
    end

    context 'when using the fast finders' do
      context 'when using the non interactive finder' do
        it 'finds size repetitions' do
          expect(fast_finder.search_repeated_files.values.first.count).to eq(FILE_PATHS.size)
        end
      end

      context 'when using the interactive finder' do
        it 'finds size repetitions' do
          expect(interactive_fast_finder.search_repeated_files.values.first.count)
            .to eq(FILE_PATHS.size)
        end
      end
    end

    context 'when using the non fast finders' do
      context 'when using the non interactive finder' do
        it 'finds the repetitions without the progress bar' do
          expect(finder.search_repeated_files.empty?).to be_falsey
        end

        it 'finds the correct repetitions without the progress bar' do
          repetitions = finder.search_repeated_files
          expect(repetitions.length).to eq(1)
          repetitions = repetitions.values.first
          expect(repetitions).not_to include(FILE_PATHS[0], FILE_PATHS[5])
          expect(repetitions).to include(FILE_PATHS[1], FILE_PATHS[2], FILE_PATHS[3],
                                         FILE_PATHS[4])
        end
      end

      context 'when using the interactive finder' do
        it 'finds the repetitions with the progress bar' do
          expect(interactive_finder.search_repeated_files.empty?).to be_falsey
        end

        it 'finds the correct repetitions with the progress bar' do
          repetitions = interactive_finder.search_repeated_files
          expect(repetitions.length).to eq(1)
          repetitions = repetitions.values.first
          expect(repetitions).not_to include(FILE_PATHS[0], FILE_PATHS[5])
          expect(repetitions).to include(FILE_PATHS[1], FILE_PATHS[2], FILE_PATHS[3],
                                         FILE_PATHS[4])
        end
      end
    end
  end
end
