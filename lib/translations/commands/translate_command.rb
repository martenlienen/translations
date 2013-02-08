module Translations
  module Commands
    class TranslateCommand
      def self.from_arguments translations, argv
        if argv.length == 0
          raise OptionParser::MissingArgument, "Which locale do you want to translate into?"
        end

        locale = argv[0]

        keys = if argv.length == 1
          translations.for_locale(locale).missing_keys_from_locale(translations.master)
        else
          [argv[1]]
        end

        new translations, locale, keys
      end

      def initialize translations, locale, keys

      end

      def run

      end
    end
  end
end
