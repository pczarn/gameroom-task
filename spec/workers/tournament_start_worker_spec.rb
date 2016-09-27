require "rails_helper"

RSpec.describe TournamentStartWorker, type: :worker do
  describe "#perform" do
    subject(:perform) { worker.perform(tournament.id, tournament.started_at) }
    let(:worker) { TournamentStartWorker.new }
    let(:tournament) { create(:tournament, number_of_teams: number_of_teams) }
    let(:number_of_teams) { 8 }

    context "when tournament is ready" do
      it "starts" do
        expect(worker).to receive(:start)
        perform
      end

      it "sets the status" do
        expect { perform }.to change { tournament.reload.started? }.to be(true)
      end

      it "creates the first round" do
        expect { perform }.to change { tournament.reload.rounds.size }.from(0).to(1)
      end

      it "creates a round with a correct number of matches" do
        perform
        tournament.reload
        expect(tournament.matches.count).to eq(number_of_teams / 2)
      end

      it "notifies players" do
        expect(UserMailer).to receive(:notify_about_tournament_start).at_least(:once)
        perform
      end
    end

    context "when tournament is not ready" do
      before do
        allow(Tournament).to receive(:find).and_return(tournament)
        allow(tournament).to receive(:can_be_started?).and_return(false)
      end

      it "does not start" do
        expect(worker).not_to receive(:start)
        perform
      end

      it "does not change status" do
        expect { perform }.not_to change { tournament.reload.open? }
      end

      it "adds a new job" do
        expect(TournamentStartWorker).to receive(:perform_in)
        perform
      end
    end

    context "when time does not match the updated time" do
      subject(:perform) { worker.perform(tournament.id, tournament.started_at - 1.day) }

      it "does not start" do
        expect(worker).not_to receive(:try_start)
        perform
      end
    end
  end
end
