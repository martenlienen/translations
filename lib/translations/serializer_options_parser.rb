module Translations
  class SerializerOptionsParser
    def initialize
      @parser = OptionParser.new
    end

    def parse argv
      options = defaults

      @parser.on "-d DIRECTORY", "--directory DIRECTORY", "" do |directory|
        options[:directory] = directory
      end

      @parser.on "-m LOCALE", "--master LOCALE", "" do |locale|
        options[:master] = locale
      end

      @parser.parse! argv

      options
    end

    def defaults
      {
        directory: "config/locales",
        master: "en"
      }
    end
  end
end
