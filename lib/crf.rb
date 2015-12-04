require 'crf/finder'
require 'crf/fast_finder'
require 'crf/remover'
require 'crf/interactive_remover'
require 'logger'
require 'colorize'

module Crf
  ##
  # This class is the Crf starting point.
  #
  class Checker
    attr_reader :path, :options, :repetitions, :space_saved, :logger

    def initialize(path, options)
      @path = path
      @options = options
      initialize_logger
    end

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
      @repetitions = Crf::Finder.new(path).search_repeated_files unless options[:fast]
      @repetitions = Crf::FastFinder.new(path).search_repeated_files if options[:fast]
    end

    def no_repetitions_found
      logger.info 'No repetitions found'
      STDOUT.puts 'No repetitions found'.blue
    end

    def repetitions_found
      logger.info "Repetitions found: #{repetitions.values}"
      remove_repetitions
      logger.info "Saved a total of #{space_saved} bytes"
      STDOUT.puts "You saved a total of #{space_saved} bytes".blue
    end

    def remove_repetitions
      remover = Crf::Remover.new(repetitions, logger) unless options[:interactive]
      remover = Crf::InteractiveRemover.new(repetitions, logger) if options[:interactive]
      @space_saved = remover.remove
    end
  end
end
