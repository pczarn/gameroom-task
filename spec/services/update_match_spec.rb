require "rails_helper"

RSpec.describe UpdateMatch do
  describe "#perform" do
    subject(:run_service) do
      service.perform
    end

    let(:service) { described_class.new(match, params: params) }
    let(:params) { { team_one_score: 0, team_two_score: 0 } }
    let(:update_match) { instance_double("UpdateMatchAttributes") }

    before do
      allow(UpdateMatchAttributes).to receive(:new).and_return(update_match)
      allow(update_match).to receive(:perform)
    end

    context "outside a tournament" do
      let(:match) { build(:match) }

      it "performs an update" do
        expect(update_match).to receive(:perform)
        run_service
      end
    end

    context "with a tournament" do
      let(:tournament) { build(:tournament, :with_rounds, number_of_rounds: 2) }
      let(:round) { tournament.rounds.first }
      let(:match) { round.matches.first }
      let(:create_next_match) { instance_double(CreateNextMatch) }
      let(:end_tournament) { instance_double(EndTournament) }

      before do
        expect(update_match).to receive(:perform)
      end

      it "performs an update" do
        run_service
      end

      context "when match is not the last one" do
        context "when the other match in pair is complete" do
          it "builds the next match" do
            expect(CreateNextMatch).to receive(:new).and_return(create_next_match)
            expect(create_next_match).to receive(:perform)
            run_service
          end
        end

        context "when the other match in pair is not complete" do
          before { round.matches[1].update!(team_one_score: nil, team_two_score: 1) }

          it "does not build the next match" do
            allow(CreateNextMatch).to receive(:new)
            expect(create_next_match).not_to receive(:perform)
            run_service
          end
        end
      end

      context "when match is the last one" do
        let(:round) { tournament.rounds.last }

        it "ends the tournament" do
          expect(EndTournament).to receive(:new).and_return(end_tournament)
          expect(end_tournament).to receive(:perform)
          run_service
        end
      end
    end
  end
end
