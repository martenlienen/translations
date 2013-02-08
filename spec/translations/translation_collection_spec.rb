require "translations/translation_collection"

describe Translations::TranslationCollection do
  describe "Loading the translation files" do
    it "should create a new Translation collection that contains the translations from the given directory" do
      assert { Translations::TranslationCollection.load("spec/fixtures/working", "en").map(&:locale).should == ["en", "de"] }
    end
  end

  it "should be Enumerable" do
    translation1 = Translations::Translation.new({ "de" => { "save" => "Speichern" } })
    translation2 = Translations::Translation.new({ "en" => { "save" => "Save" } })
    translations = Translations::TranslationCollection.new [translation1, translation2], "en"

    enumerated_translations = []

    translations.each { |translation| enumerated_translations << translation }

    assert { enumerated_translations == [translation1, translation2] }
  end
end
