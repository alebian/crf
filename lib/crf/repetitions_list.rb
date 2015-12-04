module Crf
  ##
  # This is the data structure used to get the repeated files.
  #
  class RepetitionsList
    attr_reader :uniques, :repetitions

    def initialize
      @uniques = {}
      @repetitions = {}
    end

    def add(key, value)
      return repetitions[key] << value if repetitions.key?(key)
      return repetition_found(key, value) if uniques.key?(key)
      uniques[key] = value
    end

    private

    def repetition_found(key, value)
      repetitions[key] = [value]
      repetitions[key] << uniques[key]
      uniques.delete(key)
    end
  end
end
