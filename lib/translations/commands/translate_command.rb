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

      def run

      end
    end
  end
end
