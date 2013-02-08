module Translations
  class TranslationCollection
    def self.load directory, master
      new Dir["#{directory}/*"].map { |file| Translation.load file }, master
    end

    include Enumerable

    def initialize translations, master
      @translations = translations
      @master = @translations.select { |translation| translation.locale == master }.first
    end

    def each
      @translations.each { |translation| yield translation }
    end
  end
end
