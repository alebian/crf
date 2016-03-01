require 'crf/repetitions_list'
require 'digest'
require 'ruby-progressbar'

module Crf
  class Finder
    attr_reader :path, :paths, :repetitions

    #
    # Creates the Finder object with a directory where it will look for duplicate files.
    # Path is the string representation of the absolute path of the directory.
    #
    # @param path [String] path of the root folder where the scan will start.
    # @param fast [Boolean] boolean indicating if this class will make a fast scan or not.
    #
    def initialize(path, fast = false)
      @path = path
      @fast = fast
    end

    def search_repeated_files
      @repetitions = first_run
      return repetitions if repetitions.empty? || @fast
      @repetitions = second_run(repetitions)
    end

    private

    def all_files(path)
      @paths = []
      Dir["#{path.chomp('/')}/**/*"].each { |p| paths << p.freeze if file?(p) }
      paths
    end

    def file?(path)
      !File.directory?(path) && !File.symlink?(path)
    end

    #
    # This looks for the files with the same size only
    #
    def first_run
      repetitions_list = Crf::RepetitionsList.new
      all_files(path).each do |file_path|
        repetitions_list.add(file_identifier(file_path).freeze, file_path)
      end
      repetitions_list.repetitions
    end

    def file_identifier(path)
      File.size(path).to_s
    end

    #
    # After finding files with the same size, perform a deeper analysis of those
    #
    def second_run(repetitions)
      repetitions_list = Crf::RepetitionsList.new
      repetitions.values.each do |repeated_array|
        repeated_array.each do |file_path|
          repetitions_list.add(file_hash(file_path).freeze, file_path)
        end
      end
      repetitions_list.repetitions
    end

    def file_hash(path)
      Digest::SHA256.file(path).hexdigest
    end
  end
end
