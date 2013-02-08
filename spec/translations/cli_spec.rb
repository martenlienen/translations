require "translations/cli"

describe Translations::CLI do
  describe "Option parsing" do
    let(:cli) { Translations::CLI.new ["add"] }

    context "when there is no command" do
      it "should display a help message" do
        assert { capturing { cli.build_command [] } =~ /USAGE/ }
      end
    end

    context "when the command is invalid" do
      it "should display a help message" do
        assert { capturing { cli.build_command ["unkowncommand"] } =~ /USAGE/ }
      end
    end

    context "when there is a command" do
      it "should build the associated command object" do
        assert { cli.build_command(["add"]).is_a? Translations::Commands::AddCommand }
      end
    end
  end
end