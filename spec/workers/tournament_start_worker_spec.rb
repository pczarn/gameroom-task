require "rails_helper"

RSpec.describe TournamentStartWorker, type: :worker do
  subject(:perform) { worker.perform(tournament.id, tournament.started_at) }
  let(:worker) { TournamentStartWorker.new }

  context "when tournament is ready" do
    let(:tournament) { create(:tournament) }

    it "starts" do
      # why does rubocop give a warning to use 'allow'?
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
      # expect(Round).to receive(:create) with params number:0...
      expect(tournament.rounds.find_by_number(0).matches.size).to eq(tournament.teams.size / 2)
    end
  end

  context "when tournament is not ready" do
    let(:tournament) { create(:tournament, number_of_members_per_team: 666) }

    it "does not start" do
      expect(worker).not_to receive(:start)
      perform
    end

    it "does not change status" do
      expect { perform }.not_to change { tournament.reload.open? }
    end
  end

  context "when time does not match the updated time" do
    it "does not run twice" do
      # TournamentStartWorker.perform_at()
    end
  end
end
