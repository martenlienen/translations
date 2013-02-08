require "translations/translation"

describe Translations::Translation do
  let(:translation) {
    Translations::Translation.new({
      "en" => {
        "save" => "Save",
        "buttons" => {
          "delete" => "Delete",
          "save" => "Save"
        }
      }
    })
  }

  it "should have a locale" do
    assert { translation.locale == "en" }
  end

  it "should be able to enumerate it's keys" do
    assert { translation.keys == ["save", "buttons.delete", "buttons.save"] }
  end

  it "should be able to compute the missing keys when compared to another translation" do
    translation_de = Translations::Translation.new({
      "de" => {
        "buttons" => {
          "save" => "Speichern"
        }
      }
    })

    translation_de.missing_keys_from_translation(translation).should == ["save", "buttons.delete"]
  end

  it "should expose translations through their keys" do
    assert { translation["buttons.delete"] == "Delete" }
  end

  describe "#[]=" do
    it "should let you mutate translations through their keys" do
      translation["buttons.delete"] = "Remove"

      assert { translation["buttons.delete"] == "Remove" }
    end

    it "should let you create new translations using keys" do
      translation = Translations::Translation.new({
                                                    "en" => { }
                                                  })

      translation["buttons.delete"] = "Delete"

      assert { translation["buttons.delete"] == "Delete" }
    end

    it "should expand a node when you set a key that goes 'through' another translation" do
      translation["save.success"] = "Success"

      assert { translation["save.success"] == "Success" }
    end
  end

  it "should have a Hash representation" do
    expected = {
      "en" => {
        "save" => "Save",
        "buttons" => {
          "delete" => "Delete",
          "save" => "Save"
        }
      }
    }

    assert { translation.to_hash == expected }
  end
end
