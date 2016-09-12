require "rails_helper"

RSpec.describe MatchesController, type: :controller do
  describe "#index" do
    it "responds successfully" do
      get :index
      expect(response).to be_success
    end

    it "responds with html by default" do
      get :index
      expect(response.content_type).to eq "text/html"
    end
  end

  describe "#create" do
    let(:match) { build(:match) }

    it "succeeds" do
      post :create, params: { match: match.attributes }
      expect(response).to redirect_to(assigns(:match))
    end

    it "stores a new match" do
      expect do
        post :create, params: { match: match.attributes }
      end.to change(Match, :count).by(1)
    end

    context "with invalid data" do
      let(:match) { build(:match, team_one: create(:team), played_at: nil) }

      it "gives an error message" do
        expect do
          post :create, params: { match: match.attributes }
        end.to change { flash[:error] }
          .to include("Team one can't be empty", "Played at can't be blank")
      end

      it "redirects to the index" do
        post :create, params: { match: match.attributes }
        expect(response).to redirect_to(:matches)
      end
    end
  end

  describe "#show" do
    let(:match) { create(:match) }

    it "responds successfully" do
      get :show, params: { id: match.id }
      expect(response).to be_success
    end
  end

  describe "#update" do
    let(:match) { create(:match, team_one_score: 1) }

    it "updates attributes" do
      patch :update, params: { id: match.id, match: { team_one_score: 2 } }
      expect(match.reload.team_one_score).to eq(2)
    end
  end

  describe "#destroy" do
    let!(:match) { create(:match) }

    it "removes a match" do
      expect do
        delete :destroy, params: { id: match.id }
      end.to change(Match, :count).by(-1)
    end

    it "redirects to index" do
      delete :destroy, params: { id: match.id }
      expect(response).to redirect_to(action: :index)
    end

    it "gives a message that everything is ok" do
      delete :destroy, params: { id: match.id }
      expect(flash[:success]).to eq("Match deleted")
    end
  end
end
