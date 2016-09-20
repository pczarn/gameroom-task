require "rails_helper"

RSpec.describe UserMailer, type: :mailer do
  subject(:delivery) { UserMailer.notify_about_tournament_start(user, tournament).deliver_now }
  let(:user) { build(:user) }
  let(:tournament) { build(:tournament) }

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
