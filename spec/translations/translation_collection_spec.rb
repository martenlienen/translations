require "translations/translation_collection"

describe Translations::TranslationCollection do
  let(:translation_de) { Translations::Translation.new({ "de" => { "save" => "Speichern" } }) }
  let(:translation_en) { Translations::Translation.new({ "en" => { "save" => "Save" } }) }
  let(:translations) { Translations::TranslationCollection.new [translation_de, translation_en], "en" }

  describe "Loading the translation files" do
    it "should create a new Translation collection that contains the translations from the given directory" do
      assert { Translations::TranslationCollection.load("spec/fixtures/working", "en").map(&:locale).should == ["en", "de"] }
    end
  end

  it "should be Enumerable" do
    enumerated_translations = []

    translations.each { |translation| enumerated_translations << translation }

    assert { enumerated_translations == [translation_de, translation_en] }
  end

  it "should have a master locale" do
    assert { translations.master == translation_en }
  end

  describe "#for_locale" do
    it "should return the Translation for a locale" do
      assert { translations.for_locale("de") == translation_de }
    end
  end
end
