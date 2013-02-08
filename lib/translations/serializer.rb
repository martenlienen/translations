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
      TranslationCollection.new Dir["#{@directory}/*"].map { |file| Translation.new YAML.load_file(file) }, @master
    end

    def save translations
      translations.each do |translation|
        File.open File.join(@directory, "#{translation.locale}.yml"), "w" do |file|
          file.write translation.to_hash.to_yaml
        end
      end
    end
  end
end
