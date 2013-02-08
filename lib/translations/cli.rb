require "translations/commands/add_command"

module Translations
  class CLI
    def initialize argv
      @command = build_command argv
    end

    def run
      if @command
        @command.run
      end
    end

    def build_command argv
      if argv.length == 0
        display_help_message

        nil
      else
        command = argv.shift
        command_class = "#{command.capitalize}Command".to_sym

        if Translations::Commands.const_defined? command_class
          Translations::Commands.const_get(command_class).new argv
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
