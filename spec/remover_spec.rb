require 'spec_helper'
require 'crf/logger'

describe 'Crf Remover' do
  let!(:test_files_directory) { './spec/test_files/' }
  let!(:file_1_path) { "#{test_files_directory}file_1.test" }
  let!(:file_2_path) { "#{test_files_directory}file_2.test" }
  let!(:file_3_path) { "#{test_files_directory}file_3.test" }
  let!(:file_4_path) { "#{test_files_directory}file_4.test" }
  let!(:repeated_text) { 'This text will be in 2 files' }
  let!(:unique_text) { 'This text will be in 1 file' }
  let!(:same_size_text) { 'This text has the same size' }

  describe 'deleting files' do
    let!(:finder) { Crf::Finder.new(test_files_directory) }
    let!(:logger) { Crf::Logger.new("#{test_files_directory}crf.log") }

    before :each do
      Dir.mkdir(test_files_directory) unless File.exist?(test_files_directory)
      File.open(file_1_path, 'w+') { |file| file.write(unique_text) }
      File.open(file_2_path, 'w+') { |file| file.write(repeated_text) }
      File.open(file_3_path, 'w+') { |file| file.write(repeated_text) }
      File.open(file_4_path, 'w+') { |file| file.write(same_size_text) }
    end

    it 'finds the repetitions and removes them' do
      paths = []
      Find.find(test_files_directory) { |p| paths << p unless File.directory?(p) }
      expect(paths.length).to eq(5)
      Crf::Remover.new(finder.search_repeated_files, logger).remove
      paths = []
      Find.find(test_files_directory) { |p| paths << p unless File.directory?(p) }
      expect(paths.length).to eq(4)
      expect(finder.search_repeated_files.empty?).to be_truthy
    end

    it 'does not remove unique files' do
      repetitions = finder.search_repeated_files
      Crf::Remover.new(repetitions, logger).remove
      repetitions = finder.search_repeated_files
      expect(repetitions.length).to eq(0)
    end
  end
end
