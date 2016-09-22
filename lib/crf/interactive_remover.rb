require 'colorize'
require 'pp'

module Crf
  class InteractiveRemover < Crf::Remover
    def remove
      saved = 0
      repetitions.each_value do |paths|
        print_all_paths(paths)
        paths.each do |path|
          saved += remove_confirmation(path)
        end
      end
      saved
    end

    private

    def print_all_paths(paths)
      STDOUT.puts 'Found this repetitions:'.green
      STDOUT.puts paths.pretty_inspect.green
    end

    def remove_confirmation(path)
      STDOUT.print "Do you want to delete the file #{path}? [y/n] ".yellow
      logger.write "Asking to remove #{path}"
      answer = $stdin.gets.chomp
      logger.write "User input: #{answer}"
      if answer == 'y'
        STDOUT.puts "Removed #{path}".red
        return remove_file(path)
      end
      0
    end
  end
end
