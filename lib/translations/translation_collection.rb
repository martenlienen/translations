module Translations
  class TranslationCollection
    def self.load directory, master
      new Dir["#{directory}/*"].map { |file| Translation.load file }
    end

    include Enumerable

    def initialize translations
      @translations = translations
    end

    def each
      @translations.each { |translation| yield translation }
    end
  end
end
