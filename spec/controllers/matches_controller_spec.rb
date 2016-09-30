require "rails_helper"

RSpec.describe MatchesController, type: :controller do
  before do
    sign_in
    allow(controller).to receive(:ensure_editable!)
  end

  describe "#index" do
    it "responds successfully" do
      get :index
      expect(response).to be_success
    end

    it "responds with html by default" do
      get :index
      expect(response.content_type).to eq "text/html"
    end

    describe "list of matches" do
      let(:player) { create(:user) }
      let(:user_team) { create(:user_team, user: player) }
      let!(:my_match) { create(:match, team_one: user_team.team) }
      let!(:other_match) { create(:match) }

      it "shows both matches" do
        get :index
        expect(assigns(:recent)).to include(my_match, other_match)
      end

      context "with an involving_user parameter passed" do
        it "shows the match involving the specified user" do
          get :index, params: { involving_user: player.id }
          expect(assigns(:recent)).to include(my_match)
        end

        it "does not show matches not involving the specified user" do
          get :index, params: { involving_user: player.id }
          expect(assigns(:recent)).not_to include(other_match)
        end
      end
    end
  end

  describe "#create" do
    subject(:creation) { post :create, params: { match: match.attributes } }
    let(:match) { build(:match) }

    it "succeeds and redirects to editing" do
      is_expected.to redirect_to(edit_match_path(assigns(:match)))
    end

    it "stores a new match" do
      expect { creation }.to change(Match, :count).by(1)
    end

    context "with invalid data" do
      let(:match) { build(:match, team_one_score: -1) }

      it "gives an error message" do
        expect { creation }
          .to change { flash.alert }
          .to include("Team one score must be greater than or equal to 0")
      end

      it "renders the index" do
        is_expected.to render_template "matches/index"
      end
    end
  end

  describe "#edit" do
    subject(:editing) { get :edit, params: { id: match.id } }
    let(:match) { create(:match) }

    it "ensures the user can edit the match" do
      expect(controller).to receive(:ensure_editable!)
      editing
    end

    it "responds successfully" do
      is_expected.to be_success
    end
  end

  describe "#update" do
    subject(:updating) { patch :update, params: { id: match.id, match: { team_one_score: 2 } } }
    let(:match) { create(:match, team_one_score: 1) }

    it "ensures the user can edit the match" do
      expect(controller).to receive(:ensure_editable!)
      updating
    end

    it "updates attributes" do
      expect { updating }.to change { match.reload.team_one_score }.to eq(2)
    end
  end

  describe "#destroy" do
    let!(:match) { create(:match) }
    subject(:destruction) { delete :destroy, params: { id: match.id } }

    it "ensures the user can edit the match" do
      expect(controller).to receive(:ensure_editable!)
      destruction
    end

    it "removes a match" do
      expect { destruction }.to change(Match, :count).by(-1)
    end

    it "redirects to index" do
      is_expected.to redirect_to(action: :index)
    end

    it "gives a message that everything is ok" do
      expect { destruction }.to change { flash.notice }.to include("Match deleted")
    end
  end
end
