require "translations/translation_collection"

describe Translations::TranslationCollection do
  describe "Loading the translation files" do
    it "should create a new Translation collection that contains the translations from the given directory" do
      assert { Translations::TranslationCollection.load("spec/fixtures/working", "en").map(&:locale).should == ["en", "de"] }
    end
  end

  it "should be Enumerable" do
    translation1 = double("en")
    translation2 = double("de")
    translations = Translations::TranslationCollection.new [translation1, translation2]

    enumerated_translations = []

    translations.each { |translation| enumerated_translations << translation }

    assert { enumerated_translations == [translation1, translation2] }
  end
end
