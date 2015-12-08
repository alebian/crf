require 'spec_helper'

describe 'Crf Finder' do
  let!(:test_files_directory) { './spec/test_files/' }
  let!(:file_1_path) { "#{test_files_directory}file_1.test" }
  let!(:file_2_path) { "#{test_files_directory}file_2.test" }
  let!(:file_3_path) { "#{test_files_directory}file_3.test" }
  let!(:repeated_text) { 'This text will be in 2 files' }
  let!(:unique_text) { 'This text will be in 1 file' }

  describe 'finding files' do
    let!(:finder) { Crf::Finder.new(test_files_directory) }

    before :each do
      Dir.mkdir(test_files_directory) unless File.exist?(test_files_directory)
      File.open(file_1_path, 'w+') { |file| file.write(unique_text) }
      File.open(file_2_path, 'w+') { |file| file.write(repeated_text) }
      File.open(file_3_path, 'w+') { |file| file.write(repeated_text) }
    end

    it 'finds the repetitions without the progress bar' do
      expect(finder.search_repeated_files(false).empty?).to be_falsey
    end

    it 'finds the correct repetitions without the progress bar' do
      repetitions = finder.search_repeated_files(false)
      expect(repetitions.length).to eq(1)
      repetitions = repetitions.values[0]
      expect(repetitions).not_to include(file_1_path)
      expect(repetitions).to include(file_2_path)
      expect(repetitions).to include(file_3_path)
    end

    it 'finds the repetitions with the progress bar' do
      expect(finder.search_repeated_files(true).empty?).to be_falsey
    end

    it 'finds the correct repetitions with the progress bar' do
      repetitions = finder.search_repeated_files(true)
      expect(repetitions.length).to eq(1)
      repetitions = repetitions.values[0]
      expect(repetitions).not_to include(file_1_path)
      expect(repetitions).to include(file_2_path)
      expect(repetitions).to include(file_3_path)
    end
  end
end
