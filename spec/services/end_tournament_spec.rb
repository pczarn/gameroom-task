require "rails_helper"

RSpec.describe EndTournament do
  let(:end_tournament) { described_class.new(tournament: tournament, match: match) }
  let(:tournament) { create(:tournament, :with_rounds) }
  let(:match) { tournament.rounds.first.matches.first }
  let(:mail) { double("Message") }

  before do
    allow(described_class).to receive(:delay).and_return(described_class)
  end

  describe "#perform" do
    before do
      tournament.teams = [build(:team)]
    end

    it "ends the tournament" do
      expect { end_tournament.perform }.to change { tournament.reload.ended? }.to eq(true)
    end

    it "sends mails about tournament end" do
      allow(TournamentStatusMailer).to receive(:notify_about_end).and_return(mail)
      expect(mail).to receive(:deliver).at_least(:once)
      end_tournament.perform
    end
  end
end
