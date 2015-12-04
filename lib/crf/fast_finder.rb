module Crf
  ##
  # This is a sublass of Crf::Finder.
  # It overrides the file_identifier method to make it faster and approximated.
  #
  class FastFinder < Crf::Finder
    private

    def file_identifier(path)
      File.size(path).to_s
    end
  end
end
