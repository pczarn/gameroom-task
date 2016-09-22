require "rails_helper"

RSpec.describe TournamentsController, type: :controller do
  before { sign_in }

  describe "#index" do
    it "responds successfully" do
      get :index
      expect(response).to be_success
    end

    it "responds with html by default" do
      get :index
      expect(response.content_type).to eq "text/html"
    end

    it "sets a default start time" do
      get :index
      expect(assigns(:tournament).started_at).to be_a(Time)
    end
  end

  describe "#create" do
    subject(:creation) { post :create, params: { tournament: tournament_params } }
    let(:game) { create(:game) }
    let(:attr_for_tournament) { attributes_for(:tournament).merge(game_id: game.id) }

    context "with correct params" do
      let(:tournament_params) { attr_for_tournament }

      it "does not set alerts" do
        expect { creation }.not_to change { flash.alert }
      end

      it "stores a new match" do
        expect { creation }.to change(Tournament, :count).by(1)
      end

      it "redirects" do
        expect(creation).to be_redirect
      end
    end

    context "with wrong params" do
      let(:tournament_params) { attr_for_tournament.merge(number_of_teams: 111) }

      it "assigns an object with errors" do
        creation
        expect(assigns(:tournament).errors.full_messages)
          .to include("Number of teams must be a power of 2")
      end

      it "sets alerts" do
        expect { creation }
          .to change { flash.alert }
          .to include("Number of teams must be a power of 2")
      end

      it "does not store a new match" do
        expect { creation }.not_to change(Tournament, :count)
      end

      it "renders the index" do
        is_expected.to render_template "tournaments/index"
      end
    end
  end
end
