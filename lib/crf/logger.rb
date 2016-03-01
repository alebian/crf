require 'logger'

module Crf
  class Logger
    #
    # Creates the logger with the configurations in the path provided or in the current directory
    #
    # @param path [String] path where the logger is or will be created.
    #
    def initialize(path = 'crf.log')
      @logger = ::Logger.new(path, File::CREAT)
      configurate_logger
    end

    def write(message)
      @logger.info message
    end

    private

    def configurate_logger
      @logger.datetime_format = Crf::LOGGER_DATE_TIME_FORMAT
      @logger.progname = Crf::GEM_NAME
      @logger.formatter = proc do |severity, date_time, program_name, message|
        "[#{date_time}] #{program_name}: #{message}\n"
      end
    end
  end
end
