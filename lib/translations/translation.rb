module Translations
  class Translation
    def self.load file
      new YAML.load_file(file)
    end

    attr_reader :locale

    def initialize translations
      @locale = translations.keys.first
      @translations = translations[@locale]
    end

    def keys
      keys_of_nested_hash @translations
    end

    def missing_keys_from_translation translation
      translation.keys - keys
    end

    private
    def keys_of_nested_hash hash
      hash.map do |key, value|
        if value.is_a? Hash
          keys_of_nested_hash(value).map { |nested_key| "#{key}.#{nested_key}" }
        else
          key
        end
      end.flatten 1
    end
  end
end
