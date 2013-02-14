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

  describe "#has_key?" do
    it "should return true if the key exists" do
      assert { translation.has_key?("buttons.delete") == true }
    end

    it "should return false if the key does not exist" do
      assert { translation.has_key?("key.does.not.exist") == false }
    end

    it "should return false if the key does not exist" do
      assert { translation.has_key?("buttons.xxx") == false }
    end
  end

  describe "#[]" do
    it "should expose translations through their keys" do
      assert { translation["buttons.delete"] == "Delete" }
    end

    it "should raise an exception if the key is not found" do
      assert { rescuing { translation["key.does.not.exist"] }.is_a? Translations::Translation::InvalidKeyException }
    end
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

  describe "#remove" do
    it "should remove the key" do
      translation.remove "buttons.delete"

      assert { translation.has_key?("buttons.delete") == false }
    end
  end

  describe "#move" do
    it "should move the key" do
      translation.move "buttons.delete", "actions.crud.delete"

      assert { translation["actions.crud.delete"] == "Delete" }
    end

    it "should remove the old key" do
      translation.move "buttons.delete", "actions.crud.delete"

      assert { translation.has_key?("buttons.delete") == false }
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
