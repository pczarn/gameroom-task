require "rails_helper"

RSpec.describe TournamentStatusMailer, type: :mailer do
  describe ".notify_about_start" do
    subject(:mail) { TournamentStatusMailer.notify_about_start(user.id, tournament.id) }
    let(:user) { create(:user) }
    let(:tournament) { create(:tournament) }

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

  # describe ".notify_about_start" do
  #   subject(:mail) { TournamentStatusMailer.notify_about_start(user.id, tournament.id) }
  #   let(:user) { create(:user) }
  #   let(:tournament) { create(:tournament) }

  #   it "delivers successfully" do
  #     expect { mail.deliver }.not_to raise_error
  #   end

  #   describe "#to" do
  #     it { expect(mail.to).to eq([user.email]) }
  #   end

  #   describe "#subject" do
  #     it { expect(mail.subject).to be_present }
  #   end

  #   describe "#body" do
  #     it { expect(mail.body).to be_present }
  #   end
  # end
end
