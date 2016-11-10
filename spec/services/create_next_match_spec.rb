require "rails_helper"

RSpec.describe CreateNextMatch do
  subject(:create_next_match) do
    described_class.new(tournament: tournament, round: round, match: match)
  end

  let!(:tournament) { create(:tournament, :with_rounds, number_of_rounds: 2) }
  let(:round) { tournament.rounds.first }
  let(:match) { round.matches.first }
  let(:mail) { double("Message") }

  before do
    allow(described_class).to receive(:delay).and_return(described_class)
  end

  describe "#perform" do
    it "saves the next match" do
      expect { create_next_match.perform }.to change(Match, :count).by(1)
    end

    it "sends mails about match result" do
      allow(TournamentStatusMailer).to receive(:notify_about_match_result).and_return(mail)
      expect(mail).to receive(:deliver).at_least(:once)
      create_next_match.perform
    end
  end
end
