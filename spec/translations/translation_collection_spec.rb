require "translations/translation_collection"

describe Translations::TranslationCollection do
  let(:translation_de) { Translations::Translation.new({ "de" => { "save" => "Speichern" } }) }
  let(:translation_en) { Translations::Translation.new({ "en" => { "save" => "Save" } }) }
  let(:translations) { Translations::TranslationCollection.new [translation_de, translation_en], "en" }

  it "should be Enumerable" do
    enumerated_translations = []

    translations.each { |translation| enumerated_translations << translation }

    assert { enumerated_translations == [translation_de, translation_en] }
  end

  it "should have a master locale" do
    assert { translations.master == translation_en }
  end

  it "should expose all translations that are not master as slaves" do
    assert { translations.slaves == [translation_de] }
  end

  describe "#for_locale" do
    it "should return the Translation for a locale" do
      assert { translations.for_locale("de") == translation_de }
    end
  end

  describe "#remove" do
    it "should remove the given key from all translations" do
      translations.remove "save"

      assert { translation_de.has_key?("save") == false }
      assert { translation_en.has_key?("save") == false }
    end
  end
end
