module Translations
  module Commands
    class TranslateCommand
      def self.from_arguments translations, argv
        if argv.length == 0
          raise OptionParser::MissingArgument, "Which locale do you want to translate into?"
        end

        locale = translations.for_locale(argv[0])

        keys = if argv.length == 1
          locale.missing_keys_from_translation(translations.master)
        else
          [argv[1]]
        end

        new translations, locale, keys
      end

      def initialize translations, locale, keys
        @translations = translations
        @locale = locale
        @keys = keys
      end

      def run highline, serializer
        master = @translations.master

        @keys.each do |key|
          highline.say key
          highline.say "#{master.locale}: #{master[key]}"

          @translations.slaves.each do |translation|
            answer = highline.ask "#{translation.locale}? ", String

            if answer.length > 0
              translation[key] = answer
            end

            puts
          end
        end
      end
    end
  end
end
