require "thor"

require "translations/serializer"

module Translations
  class CLI < Thor
    class_option :directory, aliases: ["-d"], default: "config/locales", type: :string, desc: "Directory containing the translations"
    class_option :master, aliases: ["-m"], default: "en", type: :string, desc: "The master locale"

    desc "translate LOCALE [KEYS]", "Translate the KEYS into the given LOCALE"
    def translate locale, *keys
      translations = serializer.translations

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

          serializer.save translations
        end
      end
    end

    desc "remove KEYS", "Remove KEYS from all locales"
    def remove *keys
      translations = serializer.translations

      keys.each do |key|
        translations.remove key
      end

      serializer.save translations
    end

    desc "move FROM TO", "Move a translation from FROM to TO"
    def move from, to
      translations = serializer.translations

      translations.move from, to

      serializer.save translations
    end

    desc "add KEY", "Add a new KEY to all translations"
    def add key
      translations = serializer.translations

      answer = ask "#{translations.master.locale}? "

      if answer.length == 0
        say "You have to provide a translation for master"

        return
      else
        translations.master[key] = answer
      end

      translations.slaves.each do |translation|
        answer = ask "#{translation.locale}? "

        if answer.length > 0
          translation[key] = answer
        end
      end

      serializer.save translations
    end

    no_tasks do
      def serializer
        @serializer ||= Serializer.new options.directory, options.master
      end
    end
  end
end
