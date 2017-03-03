require 'spec_helper'

describe 'Multiple files' do
  let(:path) { ROOT_TEST_DIRECTORY + '/multiple' }
  let(:finder) { Crf::Finder.new([path]) }
  let(:logger) { Crf::Logger.new("#{ROOT_TEST_DIRECTORY}/crf.log") }

  before do
    Dir.mkdir(path) unless Dir.exist?(path)
    (1..100).each do |index|
      File.open("#{path}/file_#{index}.txt", 'w+') { |file| file.write(REPEATED_TEXT) }
    end
    delete_logger
  end

  it 'finds and removes the repetitions' do
    repetitions = finder.search_repeated_files
    expect(finder.files.size).to eq(100)
    expect(repetitions.length).to eq(1)
    Crf::Remover.new(finder.repetitions, logger).remove
    finder.search_repeated_files
    expect(finder.paths.size).to eq(1)
  end
end
