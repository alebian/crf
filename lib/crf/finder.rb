require 'crf/repetitions_list'
require 'digest'
require 'find'
require 'ruby-progressbar'

module Crf
  #
  # This class finds the paths of all the repeated files inside the path passed as argument.
  # All files repeated have the same file_identifier.
  #
  class Finder
    attr_reader :path

    def initialize(path)
      @path = path
    end

    def search_repeated_files(progress)
      repetitions_list = with_progress_bar_search if progress
      repetitions_list = no_progress_bar_search unless progress
      confirm(repetitions_list.repetitions)
    end

    private

    def with_progress_bar_search
      repetitions_list = Crf::RepetitionsList.new
      all_paths = all_files(path)
      progressbar = ProgressBar.create(title: 'Files', total: all_paths.count,
                                       format: '%t: %c/%C %a |%B| %%%P')
      all_paths.each do |file_path|
        repetitions_list.add(file_identifier(file_path), file_path)
        progressbar.increment
      end
      repetitions_list
    end

    def no_progress_bar_search
      repetitions_list = Crf::RepetitionsList.new
      all_files(path).each do |file_path|
        repetitions_list.add(file_identifier(file_path), file_path)
      end
      repetitions_list
    end

    def all_files(path)
      paths = []
      Find.find(path) { |p| paths << p unless File.directory?(p) }
      paths
    end

    def file_identifier(path)
      File.size(path).to_s
    end

    def confirm(repetitions)
      confirmed_repetitions_list = Crf::RepetitionsList.new
      repetitions.values.each do |repeated_array|
        repeated_array.each do |file_path|
          confirmed_repetitions_list.add(file_hash(file_path), file_path)
        end
      end
      confirmed_repetitions_list.repetitions
    end

    def file_hash(path)
      Digest::SHA256.file(path).hexdigest
    end
  end
end
