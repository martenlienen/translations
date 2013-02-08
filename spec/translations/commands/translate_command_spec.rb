describe Translations::Commands::TranslateCommand do
  describe "Parsing command line arguments" do
    context "when there are no arguments" do
      it "should raise an exception" do
        assert { rescuing { Translations::Commands::TranslateCommand.from_arguments [], [] }.is_a? OptionParser::MissingArgument }
      end
    end

    context "when there is one argument" do
      it "should use all keys that are missing in the given locale" do
        missing_keys = ["a.missing_key", "a.nother.missing_key"]

        translation = Translations::Translation.new({ "en" => { "save" => "Save" } })
        translation.stub(:missing_keys_from_locale).and_return missing_keys

        translations = Translations::TranslationCollection.new [], "en"
        translations.stub(:for_locale).and_return translation

        Translations::Commands::TranslateCommand.should_receive(:new).with(translations, "en", missing_keys).and_call_original

        Translations::Commands::TranslateCommand.from_arguments translations, ["en"]
      end
    end

    context "when there are two arguments" do
      it "should treat them as locale and key" do
        Translations::Commands::TranslateCommand.should_receive(:new).with([], "en", ["a.test.key"]).and_call_original

        Translations::Commands::TranslateCommand.from_arguments [], ["en", "a.test.key"]
      end
    end
  end
end
