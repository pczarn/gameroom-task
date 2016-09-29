require "rails_helper"

describe FinishMatch do
  describe "#call" do
    subject(:run_service) { service.call }
    let(:service) { described_class.new(match, user, update: update) }
    let(:update) { instance_double("UpdateFinishedMatch") }
    let(:user) { build(:user) }

    context "outside a tournament" do
      let(:match) { build(:match) }

      it "performs an update" do
        expect(update).to receive(:perform)
        run_service
      end
    end

    context "with a tournament" do
      let(:match) { build(:match, round: tournament.rounds.first) }

      before do
        allow(service).to receive(:editable?).and_return(true)
        allow(update).to receive(:perform)
      end

      context "when tournament is ended" do
        let(:tournament) { build(:tournament, :with_rounds, number_of_rounds: 2, status: :ended) }

        it "gives an alert" do
          expect(update).to receive(:alert=).with(kind_of(String))
          run_service
        end
      end

      context "when tournament is not editable" do
        let(:tournament) { build(:tournament, :with_rounds, number_of_rounds: 2) }

        before { allow(service).to receive(:editable?).and_return(false) }

        it "gives an alert" do
          expect(update).to receive(:alert=).with(kind_of(String))
          run_service
        end
      end

      context "when tournament is started and editable" do
        let(:tournament) { build(:tournament, :with_rounds, number_of_rounds: 2) }

        before { expect(update).to receive(:perform) }

        context "when match is not the last one" do
          it "builds the next match" do
            expect(update).to receive(:next_match=).with(kind_of(Match))
            run_service
          end
        end

        context "when match is the last one" do
          it "ends the tournament" do
            expect(update).to receive(:end_tournament=).with(true)
            run_service
          end
        end
      end
    end
  end
end
