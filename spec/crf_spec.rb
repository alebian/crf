require 'spec_helper'

describe 'Crf' do
  let!(:options) { { interactive: false, progress: false, fast: false } }
  let!(:checker) { Crf::Checker.new(test_files_directory, options) }
  let!(:test_files_directory) { './spec/test_files' }
  let!(:file_paths) do
    ["#{test_files_directory}/file_1.test", "#{test_files_directory}/file_2.test"]
  end
  let!(:repeated_text) { 'This text will be in 2 files' }
  before do
    FileUtils.rm_rf(test_files_directory) if File.exist?(test_files_directory)
    Dir.mkdir(test_files_directory) unless File.exist?(test_files_directory)
    file_paths.each do |file_path|
      File.open(file_path, 'w+') { |file| file.write(repeated_text) }
    end
  end
  context 'when using the checker' do
    before do
      checker.check_repeated_files
    end
    it 'creates the logger' do
      expect(checker.logger.nil?).to be_falsey
    end
    it 'finds repetitions' do
      expect(checker.repetitions.empty?).to be_falsey
    end
    it 'deletes the repetitions' do
      checker.check_repeated_files
      expect(checker.repetitions.empty?).to be_truthy
    end
  end
end
