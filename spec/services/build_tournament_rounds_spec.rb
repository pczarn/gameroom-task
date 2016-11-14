require "rails_helper"

RSpec.describe BuildTournamentRounds do
  describe "#perform" do
    subject(:run_service) do
      service.perform
    end

    let(:service) { described_class.new(tournament) }
    let(:tournament) { build(:tournament, :with_teams, number_of_teams: number_of_teams) }
    let(:first_round) { tournament.rounds.first }

    context "when the number of teams is a power of two" do
      let(:number_of_teams) { 8 }
      let(:number_of_rounds) { 3 }

      it "builds the right number of rounds" do
        expect { run_service }.to change { tournament.rounds.length }.to eq(number_of_rounds)
      end

      it "builds the right number of matches in the first round" do
        run_service
        expect(first_round.matches.length).to eq(number_of_teams / 2)
      end

      it "does not build any matches in later rounds" do
        run_service
        expect(tournament.rounds[1..-1].map(&:matches)).to all(be_empty)
      end
    end

    context "when the number of teams is even" do
      let(:number_of_teams) { 6 }
      let(:number_of_rounds) { 3 }

      it "builds the right number of rounds" do
        expect { run_service }.to change { tournament.rounds.length }.to eq(number_of_rounds)
      end

      it "builds the right number of matches in the first round" do
        run_service
        expect(first_round.matches.length).to eq(2)
      end

      it "builds the right number of matches in the second round" do
        run_service
        expect(tournament.rounds[1].matches.length).to eq(1)
      end
    end

    context "when the number of teams is odd" do
      let(:number_of_teams) { 11 }
      let(:number_of_rounds) { 4 }

      it "builds the right number of rounds" do
        expect { run_service }.to change { tournament.rounds.length }.to eq(number_of_rounds)
      end

      it "builds the right number of matches in the first round" do
        run_service
        expect(first_round.matches.length).to eq(3)
      end

      it "builds the right number of matches in the second round" do
        run_service
        expect(tournament.rounds[1].matches.length).to eq(2)
      end
    end
  end
end
