require "rails_helper"

describe "tournament_status_mailer/notify_about_match_result.text.erb" do
  let(:match) { build(:match) }

  before do
    assign(:user, build(:user))
    assign(:winning_team, match.winning_team)
    assign(:defeated_team, match.defeated_team)
  end

  context "when user won" do
    before do
      assign(:result, :win)
      render
    end

    it "does not have leading whitespace" do
      expect(rendered).not_to be(/^\h+/)
    end

    it { expect(render).to include(" won ") }
  end

  context "when user lost" do
    before do
      assign(:result, :loss)
      render
    end

    it { expect(render).to include(" lost ") }

    it "does not have leading whitespace" do
      expect(rendered).not_to be(/^\h+/)
    end
  end

  context "when user did not participate" do
    before { render }

    it { expect(render).not_to include(" won ") }
    it { expect(render).not_to include(" lost ") }

    it "does not have leading whitespace" do
      expect(rendered).not_to be(/^\h+/)
    end
  end
end
