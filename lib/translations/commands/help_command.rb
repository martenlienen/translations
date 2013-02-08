module Translations
  module Commands
    class HelpCommand
      def self.from_arguments translations, argv
        if argv.length == 0
          raise OptionParser::MissingArgument, "Which command do you want to learn about?"
        end

        command = argv.first
        command_symbol = "#{command.capitalize}Command".to_sym

        if !Translations::Commands.const_defined? command_symbol
          raise Exception, "Unknown command: #{command}"
        end

        new Translations::Commands.const_get(command_symbol)
      end

      def initialize command_class
        @command_class = command_class
      end

      def run highline, serializer
        highline.say @command_class.usage
      end

      def self.usage
        <<-USAGE
usage: translations help COMMAND

Arguments
---------

- COMMAND: The command that want to learn about
        USAGE
      end
    end
  end
end
