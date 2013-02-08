require "highline"

require "translations/commands/help_command"
require "translations/commands/add_command"
require "translations/commands/translate_command"

require "translations/serializer"

module Translations
  class CLI
    def initialize argv
      @serializer = Serializer.load argv
      @command = build_command argv
    end

    def run
      if @command
        @command.run HighLine.new, @serializer
      end
    end

    def build_command argv
      if argv.length == 0
        display_help_message

        nil
      else
        command = argv.shift
        command_symbol = "#{command.capitalize}Command".to_sym

        if Commands.const_defined? command_symbol
          translations = @serializer.translations
          command_class = Commands.const_get(command_symbol)

          begin
            command_class.from_arguments translations, argv
          rescue Exception => e
            puts e.message, "", command_class.usage
          end
        else
          display_help_message

          nil
        end
      end
    end

    def display_help_message
      puts <<-HELP
USAGE: translations add KEY
      HELP
    end
  end
end
