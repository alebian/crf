require 'crf/repetitions_list'
require 'ruby-progressbar'

module Crf
  class InteractiveFinder < Crf::Finder
    def search_repeated_files
      all_paths = all_files
      progressbar = initialize_progress_bar('First run', all_paths.count)
      rep_list = first_run(progressbar)
      return @repetitions = rep_list.repetitions if rep_list.repetitions.empty? || @fast
      second_run(rep_list)
    end

    private

    def first_run(progressbar)
      repetitions_list = Crf::RepetitionsList.new
      all_files.each do |file_path|
        repetitions_list.add(file_identifier(file_path), file_path)
        progressbar.increment
      end
      repetitions_list
    end

    # rubocop:disable Metrics/MethodLength
    def second_run(repetitions_list)
      progressbar = initialize_progress_bar('Second run', repetitions_list.total_repetitions)
      confirmed_repetitions_list = Crf::RepetitionsList.new

      repetitions_list.repetitions.values.each do |repeated_array|
        repeated_array.each do |file_path|
          @thread_pool.post do
            confirmed_repetitions_list.add(file_hash(file_path), file_path)
            progressbar.increment
          end
        end
      end
      await_pool_termination

      @repetitions = confirmed_repetitions_list.repetitions
    end

    def initialize_progress_bar(title, total)
      ProgressBar.create(title: title, format: '%t: %c/%C %a |%B| %%%P', total: total)
    end
  end
end
