require "thor"

require "translations/serializer"

module Translations
  class CLI < Thor
    class_option :directory, aliases: ["-d"], default: "config/locales", type: :string, desc: "Directory containing the translations"
    class_option :master, aliases: ["-m"], default: "en", type: :string, desc: "The master locale"

    desc "translate LOCALE [KEYS]", "Translate the KEYS into the given LOCALE"
    long_desc <<-DESC
      Translate KEYS from the master to LOCALE. If you omit KEYS it will instead ask you to translate all keys that exist
      in master but not in LOCALE.
    DESC
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
    long_desc <<-DESC
      Add a key and provide translations for as many locales as you can.
    DESC
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
        answer = ask "#{translation.locale}?"

        if answer.length > 0
          translation[key] = answer
        end
      end

      serializer.save translations
    end

    desc "change KEY", "Change the meaning of KEY"
    long_desc <<-DESC
      Changes the meaning of KEY in a way that requires re-translation to all locales. Therefore the key will be removed
      from all locales for which you cannot provide a translation, so that it can be fixed using the translate command.
    DESC
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
    long_desc <<-DESC
      Just update KEY in LOCALE without altering any other locales.
    DESC
    def update locale, key
      translations = serializer.translations
      translation = translations.for_locale(locale)

      say "#{locale}: #{translation[key]}"
      answer = ask "#{locale}?"

      translation[key] = answer

      serializer.save translations
    end

    desc "view KEY", "View all translations for a given key"
    def view key
      serializer.translations.each do |translation|
        if translation.has_key? key
          say "#{translation.locale}: #{translation[key]}"
        else
          say "#{translation.locale} does not have key #{key}"
        end
      end
    end

    no_tasks do
      def serializer
        @serializer ||= Serializer.new options.directory, options.master
      end
    end
  end
end
