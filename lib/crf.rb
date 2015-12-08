require 'crf/finder'
require 'crf/interactive_finder'
require 'crf/remover'
require 'crf/interactive_remover'
require 'logger'
require 'colorize'

module Crf
  #
  # This class is the Crf starting point.
  #
  class Checker
    #
    # The path where it will look for repetitions, the options provided, the repetitions found,
    # the space saved and the logger files are accesible from the outside and used in the class.
    #
    attr_reader :path, :options, :repetitions, :space_saved, :logger

    #
    # Creates the object saving the directory's path and options provided. Options are set to
    # default if they are not given. It also creates the logger file.
    #
    def initialize(path, options = { interactive: false, progress: false })
      @path = path
      @options = options
      initialize_logger
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

    def initialize_logger
      @logger = Logger.new('crf.log', File::CREAT)
      logger.datetime_format = '%Y-%m-%d %H:%M:%S'
      logger.progname = 'CRF'
      logger.formatter = proc do |_severity, datetime, progname, msg|
        "[#{datetime}] #{progname}: #{msg}\n"
      end
    end

    def find_repetitions
      logger.info "Looking for repetitions in #{path}"
      @repetitions = Crf::Finder.new(path).search_repeated_files unless options[:progress]
      @repetitions = Crf::InteractiveFinder.new(path).search_repeated_files if options[:progress]
    end

    def no_repetitions_found
      logger.info 'No repetitions found'
      STDOUT.puts 'No repetitions found'.blue
    end

    def repetitions_found
      logger.info "Repetitions found: #{repetitions.values}"
      remove_repetitions
      logger.info "Saved a total of #{space_saved} bytes"
      STDOUT.puts "You saved a total of #{number_to_human_size(space_saved)}".blue
    end

    def remove_repetitions
      remover = Crf::Remover.new(repetitions, logger) unless options[:interactive]
      remover = Crf::InteractiveRemover.new(repetitions, logger) if options[:interactive]
      @space_saved = remover.remove
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
