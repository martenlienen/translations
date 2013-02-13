require "thor"

require "translations/serializer"

module Translations
  class CLI < Thor
    class_option :directory, aliases: ["-d"], default: "config/locales", type: :string, desc: "Directory containing the translations"
    class_option :master, aliases: ["-m"], default: "en", type: :string, desc: "The master locale"

    desc "translate LOCALE [KEYS]", ""
    def translate locale, *keys
      @serializer = Serializer.new options.directory, options.master
      translations = @serializer.translations

      translation = translations.for_locale(locale)

      if keys.length == 0
        keys = translation.missing_keys_from_translation(translations.master)
      end

      master = translations.master

      keys.each do |key|
        say key
        say "#{master.locale}: #{master[key]}"

        translations.slaves.each do |translation|
          answer = ask "#{translation.locale}? "

          if answer.length > 0
            translation[key] = answer
          end

          puts

          @serializer.save translations
        end
      end
    end
  end
end
