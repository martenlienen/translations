module Translations
  class Translation
    def self.load file
      new YAML.load_file(file)
    end

    attr_reader :locale

    def initialize translations
      @locale = translations.keys.first
    end
  end
end
