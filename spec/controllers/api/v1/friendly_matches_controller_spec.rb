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

RSpec.describe Api::V1::FriendlyMatchesController, type: :controller do
  let(:current_user) { create(:user) }

  before do
    sign_in(current_user)
  end

  let(:parsed_body) { JSON.parse(response.body) }

  describe "#index" do
    subject(:get_index) { get :index, params: params }
    let(:params) { {} }

    it "responds successfully" do
      expect(get_index).to be_success
    end

    it "responds with json by default" do
      expect(get_index.content_type).to eq "application/json"
    end

    describe "list of matches" do
      let(:player) { create(:user) }
      let(:user_team) { create(:user_team, user: player) }
      let!(:my_match) { create(:match, team_one: user_team.team) }
      let!(:other_match) { create(:match) }

      let(:response_match_ids) do
        parsed_body.map { |match| match["id"].to_i }
      end

      it "shows both matches" do
        get_index
        expect(response_match_ids).to include(my_match.id, other_match.id)
      end
    end
  end

  describe "#create" do
    subject(:creation) { post :create, params: { match: match.attributes } }
    let(:match) { build(:match) }

    it { is_expected.to be_success }

    it "stores a new match" do
      expect { creation }.to change(Match, :count).by(1)
    end

    context "with invalid data" do
      let(:match) { build(:match, team_one_score: -1) }

      it { is_expected.to be_unprocessable }
    end
  end

  describe "#show" do
    subject(:action) { get :show, params: { id: match.id } }
    let(:match) { create(:match, owner: current_user) }

    it { is_expected.to be_success }
  end

  describe "#update" do
    subject(:action) { patch :update, params: { id: match.id, match: { team_one_score: 2 } } }
    let(:match) { create(:match, team_one_score: 1, owner: current_user) }

    it "updates attributes" do
      expect { action }.to change { match.reload.team_one_score }.to eq(2)
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

  describe "#destroy" do
    subject(:action) { delete :destroy, params: { id: match.id } }
    let!(:match) { create(:match, owner: current_user) }

    it "removes a match" do
      expect { action }.to change(Match, :count).by(-1)
    end

    it_behaves_like "an action that modifies matches"
  end
end
