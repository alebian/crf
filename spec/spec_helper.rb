require 'support/coverage'
require 'crf'

LOGGER_PATH = './spec/crf.log'.freeze
ROOT_TEST_DIRECTORY = './spec/test_files'.freeze
FILE_DIRECTORIES = [
  ROOT_TEST_DIRECTORY,
  './spec/test_files/sub'.freeze,
  './spec/test_files/sub/sub'.freeze
].freeze
FILE_PATHS = [
  "#{ROOT_TEST_DIRECTORY}/file_1.test".freeze,
  "#{ROOT_TEST_DIRECTORY}/file_2.test".freeze,
  "#{ROOT_TEST_DIRECTORY}/file_3.test".freeze,
  "#{FILE_DIRECTORIES[1]}/file_4.test".freeze,
  "#{FILE_DIRECTORIES[2]}/file_5.test".freeze,
  "#{ROOT_TEST_DIRECTORY}/file_6.test.freeze".freeze
].freeze
REPEATED_TEXT =  'This text will be in 4 files'.freeze
UNIQUE_TEXT =    'This text will be in 1  file'.freeze
SAME_SIZE_TEXT = 'This text has the same  size'.freeze

def delete_logger
  File.delete('./spec/test_files/crf.log') if File.exist?('./spec/test_files/crf.log')
end

def create_test_files
  FILE_DIRECTORIES.each do |dir|
    Dir.mkdir(dir) unless Dir.exist?(dir)
  end
  File.open(FILE_PATHS[0], 'w+') { |file| file.write(UNIQUE_TEXT) }
  (1..4).each do |index|
    File.open(FILE_PATHS[index], 'w+') { |file| file.write(REPEATED_TEXT) }
  end
  File.open(FILE_PATHS[5], 'w+') { |file| file.write(SAME_SIZE_TEXT) }
  delete_logger
end
