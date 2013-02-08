describe Translations::Commands::AddCommand do
  describe "Parsing command line arguments" do
    it "should return a new command to add a key to a translation" do
      command = Translations::Commands::AddCommand.from_arguments Object.new, ["add", "en", "a.test.key"]

      assert { command.is_a? Translations::Commands::AddCommand }
    end
  end
end
