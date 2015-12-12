require 'crf/finder'
require 'crf/interactive_finder'
require 'crf/remover'
require 'crf/interactive_remover'
require 'crf/logger'
require 'colorize'

module Crf
  #
  # This class is the Crf starting point.
  #
  class Checker
    #
    # The path where it will look for repetitions, the options provided, the repetitions found
    # and the logger files are accesible from the outside and used in the class.
    #
    attr_reader :path, :options, :repetitions, :logger

    #
    # Creates the object saving the directory's path and options provided. Options are set to
    # default if they are not given. It also creates the logger file.
    #
    def initialize(path, options = { interactive: false, progress: false, fast: false })
      @path = path
      @options = options
      @logger = Crf::Logger.new
    end

    #
    # Starting point of Crf. You should call this if you want to check if a directory has
    # duplicated files inside.
    #
    def check_repeated_files
      find_repetitions
      return no_repetitions_found if repetitions.empty?
      repetitions_found
    end

    private

    def find_repetitions
      logger.write "Looking for repetitions in #{path}"
      if options[:progress]
        finder = Crf::InteractiveFinder.new(path, options[:fast])
      else
        finder = Crf::Finder.new(path, options[:fast])
      end
      @repetitions = finder.search_repeated_files
    end

    def no_repetitions_found
      logger.write 'No repetitions found'
      STDOUT.puts 'No repetitions found'.blue
    end

    def repetitions_found
      logger.write "Repetitions found: #{repetitions.values}"
      space_saved = remove_repetitions
      logger.write "Saved a total of #{space_saved} bytes"
      STDOUT.puts "You saved a total of #{number_to_human_size(space_saved)}".blue
    end

    def remove_repetitions
      remover = Crf::Remover.new(repetitions, logger) unless options[:interactive]
      remover = Crf::InteractiveRemover.new(repetitions, logger) if options[:interactive]
      remover.remove
    end

    def number_to_human_size(size)
      if size < 1024
        "#{size} bytes"
      elsif size < 1_048_576
        "#{(size.to_f / 1024).round(2)} KB"
      elsif size < 1_073_741_824
        "#{(size.to_f / 1_048_576).round(2)} MB"
      else
        "#{(size.to_f / 1_073_741_824).round(2)} GB"
      end
    end
  end
end
