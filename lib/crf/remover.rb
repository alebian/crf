module Crf
  ##
  # This class removes all the repetitions passed as an argument.
  # It saves the first element of the repetitions and deletes the rest.
  #
  class Remover
    attr_reader :repetitions, :logger

    def initialize(repetitions, logger)
      @repetitions = repetitions
      @logger = logger
    end

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
      logger.info "Removed #{path}, size: #{size} bytes"
    end
  end
end
