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
  end
end
