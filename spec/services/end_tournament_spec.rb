require "rails_helper"

RSpec.describe EndTournament do
  let(:end_tournament) { described_class.new(tournament: tournament, match: match) }
  let(:tournament) { create(:tournament, :with_teams, :with_rounds) }
  let(:match) { tournament.rounds.first.matches.first }

  describe "#perform" do
    before do
      tournament.teams = [build(:team)]
    end

    it "ends the tournament" do
      expect { end_tournament.perform }.to change { tournament.reload.ended? }.to eq(true)
    end

    it "runs a worker" do
      expect(TournamentEndWorker).to receive(:perform_async)
      end_tournament.perform
    end
  end
end
