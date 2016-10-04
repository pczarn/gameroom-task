require "rails_helper"

shared_examples_for "mail_sender" do
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
    let(:user) { create(:user) }

    it_behaves_like "mail_sender"
  end

  describe ".notify_about_end" do
    subject(:mail) { TournamentStatusMailer.notify_about_end(user.id, tournament.id, team.id) }
    let(:team) { create(:team) }
    let(:user) { create(:user) }

    it_behaves_like "mail_sender"
  end

  describe ".notify_about_match_result" do
    subject(:mail) { TournamentStatusMailer.notify_about_match_result(user.id, match.id) }
    let(:round) { create(:round, tournament: tournament) }
    let(:user) { create(:user) }

    let(:match) do
      create(
        :match,
        round: round,
        played_after: tournament.started_at,
        team_one_score: 1,
        team_two_score: 0,
      )
    end

    context "when the user wins" do
      before { match.team_one.members << user }

      it "includes correct information about the result" do
        expect(mail.body.encoded).to include("You won the match")
      end
    end

    context "when the user loses" do
      before { match.team_two.members << user }

      it "includes correct information about the result" do
        expect(mail.body.encoded).to include("You lost the match")
      end
    end

    context "when the user is not a participant" do
      it "includes correct information about the result" do
        expect(mail.body.encoded).to include("The match is finished")
      end
    end

    it_behaves_like "mail_sender"
  end
end
