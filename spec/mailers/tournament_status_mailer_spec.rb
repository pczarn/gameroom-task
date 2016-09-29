require "rails_helper"

shared_examples_for "mail_sender" do
  let(:user) { create(:user) }

  it "delivers successfully" do
    expect { mail.deliver }.not_to raise_error
  end

  describe "#to" do
    it { expect(mail.to).to eq([user.email]) }
  end

  describe "#subject" do
    it { expect(mail.subject).to be_present }
  end

  describe "#body" do
    it { expect(mail.body).to be_present }
  end
end

RSpec.describe TournamentStatusMailer, type: :mailer do
  let(:tournament) { create(:tournament) }

  describe ".notify_about_start" do
    subject(:mail) { TournamentStatusMailer.notify_about_start(user.id, tournament.id) }

    it_behaves_like "mail_sender"
  end

  describe ".notify_about_end" do
    subject(:mail) { TournamentStatusMailer.notify_about_end(user.id, tournament.id, team.id) }
    let(:team) { create(:team) }

    it_behaves_like "mail_sender"
  end

  describe ".notify_about_match_result" do
    subject(:mail) { TournamentStatusMailer.notify_about_match_result(user.id, match.id) }
    let(:round) { create(:round, tournament: tournament) }
    let(:match) { create(:match, round: round, played_after: tournament.started_at) }

    it_behaves_like "mail_sender"
  end
end
