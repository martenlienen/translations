require "translations/serializer"

describe Translations::Serializer do
  describe "Parsing of command line arguments" do
    it "should return a serializer" do
      assert { Translations::Serializer.load([]).is_a? Translations::Serializer }
    end

    it "should take arguments for the base directory and master" do
      Translations::Serializer.should_receive(:new).with("path/to/translations", "de")

      Translations::Serializer.load ["-d", "path/to/translations", "-m", "de"]
    end
  end

  describe "#translations" do
    let(:serializer) { Translations::Serializer.new("spec/fixtures/working", "en") }

    it "should parse YAML files into a TranslationCollection" do
      assert { serializer.translations.is_a? Translations::TranslationCollection }
    end

    it "should create a translation for every found locale" do
      locales = serializer.translations.map(&:locale)

      assert { locales.== ["en", "de"] }
    end

    it "should set the master correctly" do
      assert { serializer.translations.master.locale == "en" }
    end
  end

  describe "#save" do
    before :each do
      if File.exists? "/tmp/de.yml"
        File.delete "/tmp/de.yml"
      end
    end

    it "should write the YAML serialization of the translations into the files" do
      translation = Translations::Translation.new({
        "de" => {
          "save" => "Speichern"
        }
      })

      translations = Translations::TranslationCollection.new [translation], "de"

      serializer = Translations::Serializer.new "/tmp/", "de"

      serializer.save translations

      assert { File.exists?("/tmp/de.yml") }
    end

    it "should output the keys in alphabetical order" do
      translations_hash = {
        "en" => {
          "animals" => {
            "mammals" => {
              "elephant" => "Elephant",
              "human" => "Human"
            },
            "fish" => {
              "trout" => "Trout",
              "bass" => "Bass",
              "mackerel" => "Mackerel"
            }
          },
          "actions" => {
            "save" => "Save",
            "add" => "Add",
            "delete" => "Delete"
          }
        }
      }

      translation = Translations::Translation.new(translations_hash)
      translations = Translations::TranslationCollection.new [translation], "en"
      serializer = Translations::Serializer.new "/tmp/", "en"

      serializer.save translations

      assert { YAML.load_file("/tmp/en.yml") == translations_hash }
    end
  end
end
