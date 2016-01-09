require 'spec_helper'
require 'crf/logger'

def delete_logger
  File.delete('./spec/test_files/crf.log') if File.exist?('./spec/test_files/crf.log')
end

describe 'Crf Remover' do
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

  context 'when deleting files' do
    let!(:finder) { Crf::Finder.new(test_files_directories.first) }
    let!(:logger) { Crf::Logger.new("#{test_files_directories.first}/crf.log") }

    before :each do
      test_files_directories.each do |dir|
        Dir.mkdir(dir) unless File.exist?(dir)
      end
      File.open(file_paths[0], 'w+') { |file| file.write(unique_text) }
      File.open(file_paths[1], 'w+') { |file| file.write(repeated_text) }
      File.open(file_paths[2], 'w+') { |file| file.write(repeated_text) }
      File.open(file_paths[3], 'w+') { |file| file.write(repeated_text) }
      File.open(file_paths[4], 'w+') { |file| file.write(repeated_text) }
      File.open(file_paths[5], 'w+') { |file| file.write(same_size_text) }
      delete_logger
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
  end
end
