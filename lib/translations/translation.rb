module Translations
  class Translation
    class InvalidKeyException < ArgumentError

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

    def has_key? key
      translation = key.split(".").inject(@translations) do |translation, key|
        if translation.nil?
          nil
        else
          translation[key]
        end
      end

      translation != nil
    end

    def [] key
      key.split(".").inject(@translations) do |translation, key|
        if translation.nil?
          raise InvalidKeyException
        else
          translation[key]
        end
      end
    end

    def []= key, value
      parts = key.split(".")

      hash = parts.slice(0, parts.length - 1).inject(@translations) do |translation, key|
        if !translation.has_key? key
          translation[key] = { }
        end

        if !translation[key].is_a? Hash
          translation[key] = { }
        end

        translation[key]
      end

      hash[parts.last] = value
    end

    def remove key
      parts = key.split(".")
      last_part = parts.pop

      parent = parts.inject(@translations) do |translation, key|
        translation[key]
      end

      parent.delete last_part
    end

    def move from, to
      self[to] = self[from]

      remove from
    end

    def to_hash
      { @locale => @translations }
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
