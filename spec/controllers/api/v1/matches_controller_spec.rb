require "rails_helper"

shared_examples_for "an action that modifies matches" do
  context "when the user owns the match" do
    it { is_expected.to be_success }
  end

  context "when the user is an admin" do
    let(:current_user) { create(:user, role: :admin) }
    before { match.update(owner: nil) }

    it { is_expected.to be_success }
  end

  context "when the user should not have access" do
    before { match.update!(owner: nil) }

    it { is_expected.to be_forbidden }
  end
end

RSpec.describe Api::V1::MatchesController, type: :controller do
  let(:current_user) { create(:user) }

  before do
    sign_in(current_user)
  end

  describe "#update" do
    subject(:action) { patch :update, params: { id: match.id, match: { team_one_score: 2 } } }
    let(:match) { create(:match, team_one_score: 1, owner: current_user) }

    it "updates attributes" do
      expect { action }.to change { match.reload.team_one_score }.to eq(2)
    end

    it "calls a service to update the match" do
      service = instance_double(UpdateMatch)
      allow(UpdateMatch).to receive(:new).and_return(service)
      expect(service).to receive(:perform)
      action
    end

    context "when the user participates in the match" do
      before do
        match.team_one.members << current_user
        match.owner = nil
        match.save!
      end

      it { is_expected.to be_success }
    end

    it_behaves_like "an action that modifies matches"
  end
end
