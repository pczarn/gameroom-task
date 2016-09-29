require "rails_helper"

RSpec.describe TournamentsController, type: :controller do
  let(:current_user) { build(:user) }
  before { sign_in(current_user) }

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

  describe "#edit" do
    subject { get :edit, params: { id: tournament.id } }
    let(:tournament) { create(:tournament) }

    it "responds successfully" do
      is_expected.to be_success
    end
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

      it "does not update attributes" do
        expect { updating }.not_to change { tournament.reload.title }
      end
    end
  end

  describe "#destroy" do
    let!(:tournament) { create(:tournament, owner: current_user) }
    subject(:destruction) { delete :destroy, params: { id: tournament.id } }

    context "when the tournament is open" do
      it "removes a tournament" do
        expect { destruction }.to change(Tournament, :count).by(-1)
      end
    end

    context "when the tournament is not open" do
      before { tournament.started! }

      it "does not remove the tournament" do
        expect { destruction }.not_to change(Tournament, :count)
      end
    end

    it "redirects to index" do
      is_expected.to redirect_to tournaments_path
    end
  end

  describe "#add_team" do
    subject(:adding) { post :add_team, params: params }
    let(:tournament) { create(:tournament, owner: current_user) }
    let(:members) { create_list(:user, 3) }
    let(:params) { { tournament_id: tournament.id, team: team_params } }
    let(:team_params) { { name: "foo", member_ids: members.pluck(:id) } }

    context "when the tournament is open" do
      context "when adding a unique team" do
        it "adds the team" do
          expect { adding }.to change { tournament.teams.count }.by(1)
        end
      end

      context "when adding a duplicate team" do
        before { create(:team, name: "bar", members: members) }

        it "adds a reused the team" do
          expect { adding }
            .to change { tournament.reload.teams.pluck(:name) }
            .to include("bar")
        end
      end
    end

    context "when the tournament is not open" do
      before { tournament.started! }

      it "does not add the team" do
        expect { adding }.not_to change { tournament.teams.count }
      end
    end
  end

  describe "#remove_team" do
    subject(:removing) { post :remove_team, params: params }
    let(:params) { { tournament_id: tournament.id, team_id: team.id } }
    let(:tournament) { create(:tournament, teams: [team], owner: current_user) }
    let(:team) { create(:team) }

    context "when the tournament is open" do
      it "removes the team" do
        expect { removing }.to change { tournament.teams.count }.by(-1)
      end
    end

    context "when the tournament is not open" do
      before { tournament.started! }

      it "does not remove the team" do
        expect { removing }.not_to change { tournament.teams.count }
      end
    end
  end
end
