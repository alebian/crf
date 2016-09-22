require 'spec_helper'

describe 'Crf' do
  let!(:options) { { interactive: false, progress: false, fast: false } }
  let!(:checker) { Crf::Checker.new(test_files_directories, options) }
  let!(:test_files_directories) { ['./spec/test_files'] }
  let!(:file_paths) do
    ["#{test_files_directories[0]}/file_1.test", "#{test_files_directories[0]}/file_2.test"]
  end
  let!(:repeated_text) { 'This text will be in 2 files' }

  before do
    test_files_directories.each do |directory|
      FileUtils.rm_rf(directory) if File.exist?(directory)
      Dir.mkdir(directory) unless Dir.exist?(directory)
    end
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

  describe '#number_to_human_size' do
    let(:bytes) { 300 }
    let(:kbytes) { 3_000 }
    let(:mbytes) { 3_000_000 }
    let(:gbytes) { 3_000_000_000 }

    it 'prints bytes' do
      expect(checker.send(:number_to_human_size, bytes)).to eq('300 bytes')
    end

    it 'prints KB' do
      expect(checker.send(:number_to_human_size, kbytes)).to eq('2.93 KB')
    end

    it 'prints MB' do
      expect(checker.send(:number_to_human_size, mbytes)).to eq('2.86 MB')
    end

    it 'prints GB' do
      expect(checker.send(:number_to_human_size, gbytes)).to eq('2.79 GB')
    end
  end
end
