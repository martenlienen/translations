require "translations/translation"

describe Translations::Translation do
  describe "Loading a translation file" do
    it "should return a Translation object for the given translation file" do
      assert { Translations::Translation.load("spec/fixtures/working/en.yml").locale == "en" }
    end
  end

  describe "A Translation" do
    it "should have a locale" do
      translation = Translations::Translation.new({
        "en" => {
          "save" => "Save"
        }
      })

      assert { translation.locale == "en" }
    end

    it "should be able to enumerate it's keys" do
      translation = Translations::Translation.new({
        "en" => {
          "save" => "Save",
          "buttons" => {
            "delete" => "Delete",
            "save" => "Save"
          }
        }
      })

      assert { translation.keys == ["save", "buttons.delete", "buttons.save"] }
    end

    it "should be able to compute the missing keys when compared to another translation" do
      translation_en = Translations::Translation.new({
        "en" => {
          "save" => "Save",
          "buttons" => {
            "delete" => "Delete",
            "save" => "Save"
          }
        }
      })

      translation_de = Translations::Translation.new({
        "de" => {
          "buttons" => {
            "save" => "Speichern"
          }
        }
      })

      translation_de.missing_keys_from_translation(translation_en).should == ["save", "buttons.delete"]
    end
  end
end
