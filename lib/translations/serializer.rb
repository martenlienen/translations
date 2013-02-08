require "translations/serializer_options_parser"
require "translations/translation_collection"

module Translations
  class Serializer
    def self.load argv
      parser = SerializerOptionsParser.new
      options = parser.parse argv

      new options[:directory], options[:master]
    end

    def initialize directory, master
      @directory = directory
      @master = master
    end

    def translations
      TranslationCollection.new Dir["#{@directory}/*"].map { |file| Translation.load file }, @master
    end
  end
end
