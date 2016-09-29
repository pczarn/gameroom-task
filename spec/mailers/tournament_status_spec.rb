require "rails_helper"

RSpec.describe TournamentStatusMailer, type: :mailer do
  describe ".notify_about_start" do
    subject(:delivery) { TournamentStatusMailer.notify_about_start(user.id, tournament.id) }
    let(:user) { create(:user) }
    let(:tournament) { create(:tournament) }

    it "delivers successfully" do
      expect { delivery }.not_to raise_error
    end

    it "is added to the delivery queue" do
      expect { delivery }.to change(ActionMailer::Base.deliveries, :size).by(1)
    end

    it "includes the correct recipient" do
      delivery
      expect(ActionMailer::Base.deliveries.last.to[0]).to include(user.email)
    end
  end
end
