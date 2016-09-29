require "rails_helper"

RSpec.describe FinishMatch do
  describe "#call" do
    subject(:run_service) { service.call }
    let(:service) { described_class.new(match, current_user: user, update: update) }
    let(:update) { instance_double("UpdateFinishedMatch") }
    let(:user) { build(:user) }

    before do
      allow(update).to receive(:params).and_return(team_one_score: 0, team_two_score: 0)
    end

    context "outside a tournament" do
      let(:match) { build(:match) }

      it "performs an update" do
        expect(update).to receive(:perform)
        run_service
      end
    end

    context "with a tournament" do
      let(:tournament) { build(:tournament, :with_rounds, number_of_rounds: 2) }
      let(:round) { tournament.rounds.first }
      let(:match) { round.matches.first }

      before do
        allow(service).to receive(:editable?).and_return(true)
        allow(update).to receive(:perform)
      end

      context "when tournament is ended" do
        before { tournament.ended! }

        it "gives an alert" do
          expect(update).to receive(:alert=).with(kind_of(String))
          run_service
        end
      end

      context "when tournament is not editable" do
        before { allow(service).to receive(:editable?).and_return(false) }

        it "gives an alert" do
          expect(update).to receive(:alert=).with(kind_of(String))
          run_service
        end
      end

      context "when tournament is started and editable" do
        before { expect(update).to receive(:perform) }

        context "when match is not the last one" do
          it "builds the next match" do
            expect(update).to receive(:next_match=).with(kind_of(Match))
            run_service
          end
        end

        context "when match is the last one" do
          let(:round) { tournament.rounds.last }

          it "ends the tournament" do
            expect(update).to receive(:end_tournament=).with(true)
            run_service
          end
        end
      end
    end
  end
end

RSpec.describe UpdateFinishedMatch do
  subject(:update) { described_class.new(match: match, tournament: tournament, params: params) }
  let(:tournament) { create(:tournament, :with_rounds) }
  let(:match) { tournament.rounds.first.matches.first }
  let(:params) { { team_one_score: 1, team_two_score: 2 } }
  let(:mail) { double("Message") }

  describe "#perform" do
    it "works" do
      expect { update.perform }.not_to raise_error
    end

    before do
      allow(described_class).to receive(:delay).and_return(described_class)
    end

    context "when #next_match is set" do
      let(:next_match) { build(:match) }

      before do
        update.next_match = next_match
      end

      it "saves the next match" do
        expect { update.perform }.to change { next_match.persisted? }.to eq(true)
      end

      it "sends mails about match result" do
        allow(TournamentStatusMailer).to receive(:notify_about_match_result).and_return(mail)
        expect(mail).to receive(:deliver).at_least(:once)
        update.perform
      end
    end

    context "when #end_tournament is set to true" do
      before do
        update.end_tournament = true
        tournament.teams = [build(:team)]
      end

      it "ends the tournament" do
        expect { update.perform }.to change { tournament.reload.ended? }.to eq(true)
      end

      it "sends mails about tournament end" do
        allow(TournamentStatusMailer).to receive(:notify_about_end).and_return(mail)
        expect(mail).to receive(:deliver).at_least(:once)
        update.perform
      end
    end
  end
end
