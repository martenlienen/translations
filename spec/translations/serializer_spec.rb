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
end
