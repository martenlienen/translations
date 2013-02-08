require "translations/commands/add_command"
require "translations/global_options_parser"
require "translations/translation_collection"

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

        parser = GlobalOptionsParser.new
        options = parser.parse argv
        translations = TranslationCollection.load options[:directory], options[:master]

        if Commands.const_defined? command_class
          Commands.const_get(command_class).new translations, argv
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
