require 'logger'

module Crf
  #
  # This class is a wrapper of the Logger class, it hanldes the creation and sets the configuration
  #
  class Logger
    #
    # Creates the logger with the configurations in the path provided or in the current directory
    #
    def initialize(path = 'crf.log')
      @logger = ::Logger.new(path, File::CREAT)
      configurate_logger
    end

    #
    # Wrapper of the Logger info method
    #
    def info(msg)
      @logger.info msg
    end

    private

    def configurate_logger
      @logger.datetime_format = '%Y-%m-%d %H:%M:%S'
      @logger.progname = 'CRF'
      @logger.formatter = proc do |_severity, datetime, progname, msg|
        "[#{datetime}] #{progname}: #{msg}\n"
      end
    end
  end
end
