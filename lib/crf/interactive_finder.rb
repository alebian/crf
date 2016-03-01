require 'crf/repetitions_list'
require 'ruby-progressbar'

module Crf
  class InteractiveFinder < Crf::Finder

    def search_repeated_files
      all_paths = all_files(path)
      progressbar = ProgressBar.create(title: 'First run', total: all_paths.count,
                                       format: '%t: %c/%C %a |%B| %%%P')
      rep_list = first_run(progressbar)
      return @repetitions = rep_list.repetitions if rep_list.repetitions.empty? || @fast
      second_run(rep_list)
    end

    private

    def first_run(progressbar)
      repetitions_list = Crf::RepetitionsList.new
      all_files(path).each do |file_path|
        repetitions_list.add(file_identifier(file_path), file_path)
        progressbar.increment
      end
      repetitions_list
    end

    def second_run(repetitions_list)
      progressbar = ProgressBar.create(title: 'Second run', format: '%t: %c/%C %a |%B| %%%P',
                                       total: repetitions_list.total_repetitions)
      confirmed_repetitions_list = Crf::RepetitionsList.new
      repetitions_list.repetitions.values.each do |repeated_array|
        repeated_array.each do |file_path|
          confirmed_repetitions_list.add(file_hash(file_path), file_path)
          progressbar.increment
        end
      end
      @repetitions = confirmed_repetitions_list.repetitions
    end
  end
end
