module Crf
  class Remover
    attr_reader :repetitions, :logger

    ##
    # This object needs the repeated files obtained with Crf::Finder and the logger object.
    #
    # @param repetitions [Hash] repetitions found by one of the finder classes.
    # @param logger [Crf::Logger] logger file which this class will write.
    #
    def initialize(repetitions, logger)
      @repetitions = repetitions
      @logger = logger
    end

    ##
    # This method removes all the files contained on each value of the repetitions hash
    # except the first one. This is done without asking the user for confirmation.
    #
    def remove
      saved = 0
      repetitions.each_value do |paths|
        paths.delete_at(0)
        paths.each do |path|
          saved += remove_file(path)
        end
      end
      saved
    end

    private

    def remove_file(path)
      size = File.size(path)
      begin
        File.delete(path)
        log_removal(path, size)
        return size
      rescue
        return 0
      end
    end

    def log_removal(path, size)
      logger.write "Removed #{path}, size: #{size} bytes"
    end
  end
end
