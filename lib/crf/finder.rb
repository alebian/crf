require 'crf/repetitions_list'
require 'digest'
require 'find'

module Crf
  ##
  # This class finds the paths of all the repeated files inside the path passed as argument.
  # All files repeated have the same file_identifier.
  #
  class Finder
    attr_reader :path

    def initialize(path)
      @path = path
    end

    def search_repeated_files
      repetitions_list = Crf::RepetitionsList.new
      all_files(path).each do |file_path|
        repetitions_list.add(file_identifier(file_path), file_path)
      end
      repetitions_list.repetitions
    end

    private

    def all_files(path)
      paths = []
      Find.find(path) { |p| paths << p unless File.directory?(p) }
      paths
    end

    def file_identifier(path)
      Digest::SHA256.file(path).hexdigest
    end
  end
end
