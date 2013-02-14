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
          answer = ask "#{translation.locale}?"

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

      answer = ask "#{translations.master.locale}?"

      if answer.length > 0
        translations.master[key] = answer
      else
        say "You have to provide a translation for master"

        return
      end

      translations.slaves.each do |translation|
        answer = ask "#{translation.locale}? "

        if answer.length > 0
          translation[key] = answer
        end
      end

      serializer.save translations
    end

    desc "change KEY", "Change the meaning of KEY"
    def change key
      translations = serializer.translations

      say "#{translations.master.locale}: #{translations.master[key]}"
      answer = ask "#{translations.master.locale}?"

      if answer.length > 0
        translations.master[key] = answer
      else
        say "You have to provide a translation for master"

        return
      end

      translations.slaves.each do |translation|
        say "#{translation.locale}: #{translation[key]}"
        answer = ask "#{translation.locale}?"

        if answer.length > 0
          translation[key] = answer
        else
          translation.remove key
        end
      end

      serializer.save translations
    end

    desc "update LOCALE KEY", "Update KEY in a specific LOCALE without changing it's meaning"
    def update locale, key
      translations = serializer.translations
      translation = translations.for_locale(locale)

      say "#{locale}: #{translation[key]}"
      answer = ask "#{locale}?"

      translation[key] = answer

      serializer.save translations
    end

    no_tasks do
      def serializer
        @serializer ||= Serializer.new options.directory, options.master
      end
    end
  end
end
