require "rails_helper"

RSpec.describe TournamentEndWorker, type: :worker do
  describe "#perform" do
    subject(:perform) { worker.perform(tournament.id, match.id) }
    let(:worker) { TournamentEndWorker.new }
    let(:tournament) { create(:tournament, :with_teams, :with_rounds) }
    let(:match) { tournament.rounds.first.matches.first }
    let(:mail) { double("Message") }

    it "broadcasts the update" do
      expect(TournamentsChannel).to receive(:update)
      perform
    end

    it "sends mails about tournament end" do
      allow(TournamentStatusMailer).to receive(:notify_about_end).and_return(mail)
      expect(mail).to receive(:deliver).at_least(:once)
      perform
    end
  end
end
