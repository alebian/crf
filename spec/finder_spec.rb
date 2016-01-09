require 'spec_helper'

def delete_logger
  File.delete('./spec/test_files/crf.log') if File.exist?('./spec/test_files/crf.log')
end

describe 'Crf Finder' do
  let!(:test_files_directories) do
    ['./spec/test_files', './spec/test_files/sub', './spec/test_files/sub/sub']
  end
  let!(:file_paths) do
    ["#{test_files_directories.first}/file_1.test", "#{test_files_directories.first}/file_2.test",
     "#{test_files_directories.first}/file_3.test", "#{test_files_directories[1]}/file_4.test",
     "#{test_files_directories[2]}/file_5.test", "#{test_files_directories.first}/file_6.test"]
  end
  let!(:repeated_text)  { 'This text will be in 4 files' }
  let!(:unique_text)    { 'This text will be in 1  file' }
  let!(:same_size_text) { 'This text has the same  size' }

  context 'when finding files' do
    let!(:finder)                  { Crf::Finder.new(test_files_directories.first) }
    let!(:fast_finder)             { Crf::Finder.new(test_files_directories.first, true) }
    let!(:interactive_finder)      { Crf::InteractiveFinder.new(test_files_directories.first) }
    let!(:interactive_fast_finder) do
      Crf::InteractiveFinder.new(test_files_directories.first, true)
    end

    before do
      test_files_directories.each do |dir|
        Dir.mkdir(dir) unless File.exist?(dir)
      end
      File.open(file_paths[0], 'w+') { |file| file.write(unique_text) }
      File.open(file_paths[1], 'w+') { |file| file.write(repeated_text) }
      File.open(file_paths[2], 'w+') { |file| file.write(repeated_text) }
      File.open(file_paths[3], 'w+') { |file| file.write(repeated_text) }
      File.open(file_paths[4], 'w+') { |file| file.write(repeated_text) }
      File.open(file_paths[5], 'w+') { |file| file.write(same_size_text) }
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
        expect(interactive_finder.paths.size).to eq(file_paths.size)
        expect(finder.paths.size).to eq(file_paths.size)
        expect(interactive_fast_finder.paths.size).to eq(file_paths.size)
        expect(fast_finder.paths.size).to eq(file_paths.size)
      end
    end
    context 'when using the fast finders' do
      context 'when using the non interactive finder' do
        it 'finds size repetitions' do
          expect(fast_finder.search_repeated_files.values.first.count).to eq(file_paths.size)
        end
      end
      context 'when using the interactive finder' do
        it 'finds size repetitions' do
          expect(interactive_fast_finder.search_repeated_files.values.first.count)
            .to eq(file_paths.size)
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
          expect(repetitions).not_to include(file_paths[0], file_paths[5])
          expect(repetitions).to include(file_paths[1], file_paths[2], file_paths[3],
                                         file_paths[4])
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
          expect(repetitions).not_to include(file_paths[0], file_paths[5])
          expect(repetitions).to include(file_paths[1], file_paths[2], file_paths[3],
                                         file_paths[4])
        end
      end
    end
  end
end
