require "rails_helper"

RSpec.describe Api::V1::TournamentsController, type: :controller do
  let(:current_user) { create(:user) }
  before { sign_in(current_user) }
  let(:parsed_body) { JSON.parse(response.body) }

  describe "#index" do
    subject(:get_index) { get :index }

    it { is_expected.to be_success }

    it "responds with json by default" do
      expect(get_index.content_type).to eq "application/json"
    end
  end

  describe "#create" do
    subject(:creation) { post :create, params: { tournament: tournament_params } }
    let(:game) { create(:game) }
    let(:attr_for_tournament) { attributes_for(:tournament).merge(game_id: game.id) }

    context "with correct params" do
      let(:tournament_params) { attr_for_tournament }

      it { is_expected.to be_success }

      it "stores a new match" do
        expect { creation }.to change(Tournament, :count).by(1)
      end
    end

    context "with wrong params" do
      let(:tournament_params) { attr_for_tournament.merge(number_of_teams: 111) }

      it { is_expected.to be_unprocessable }

      it "responds with an error" do
        creation
        expect(parsed_body["error"])
          .to include("Number of teams must be a power of 2")
      end

      it "does not store a new match" do
        expect { creation }.not_to change(Tournament, :count)
      end
    end
  end

  describe "#show" do
    subject { get :show, params: { id: tournament.id } }
    let(:tournament) { create(:tournament) }

    it { is_expected.to be_success }
  end

  describe "#update" do
    subject(:updating) { patch :update, params: params }
    let(:params) { { id: tournament.id, tournament: { title: "bar" } } }
    let(:tournament) { create(:tournament, title: "foo", owner: owner) }

    context "when tournament owner is logged in" do
      let(:owner) { current_user }

      it "updates attributes" do
        expect { updating }.to change { tournament.reload.title }.to eq("bar")
      end
    end

    context "when tournament owner is not logged in" do
      let(:owner) { build(:user) }

      it { is_expected.to be_forbidden }
    end
  end

  describe "#destroy" do
    let!(:tournament) { create(:tournament, owner: current_user) }
    subject(:destruction) { delete :destroy, params: { id: tournament.id } }

    context "when the tournament is open" do
      it { is_expected.to be_success }

      it "removes a tournament" do
        expect { destruction }.to change(Tournament, :count).by(-1)
      end
    end

    context "when the tournament is not open" do
      before { tournament.started! }

      it { is_expected.to be_forbidden }

      it "does not remove the tournament" do
        expect { destruction }.not_to change(Tournament, :count)
      end
    end
  end
end
