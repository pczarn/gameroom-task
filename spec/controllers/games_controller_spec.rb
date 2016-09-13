require "rails_helper"

RSpec.describe GamesController, type: :controller do
  describe "#index" do
    it "responds successfully" do
      get :index
      expect(response).to be_success
    end

    it "responds with html by default" do
      get :index
      expect(response.content_type).to eq "text/html"
    end

    describe "list of games" do
      before { create_list(:game, 3) }

      it "shows both matches" do
        get :index
        expect(assigns(:games).length).to be(3)
      end
    end
  end

  describe "#create" do
    context "with valid data" do
      let(:game) { build(:game) }

      it "succeeds" do
        post :create, params: { game: game.attributes }
        expect(response).to redirect_to(assigns(:game))
      end

      it "stores a new game" do
        expect do
          post :create, params: { game: game.attributes }
        end.to change(Game, :count).by(1)
      end
    end

    context "with invalid data" do
      let(:game) { build(:game, name: "") }

      it "sends an error message" do
        expect do
          post :create, params: { game: game.attributes }
        end.to change { flash[:error] }
          .to include("Name can't be blank")
      end

      it "redirects to the index" do
        post :create, params: { game: game.attributes }
        expect(response).to redirect_to(:games)
      end
    end

    context "with no image" do
      let(:game) { build(:game, image: nil) }

      it "succeeds" do
        post :create, params: { game: game.attributes }
        expect(response).to redirect_to(assigns(:game))
      end
    end
  end

  describe "#show" do
    let(:game) { create(:game) }

    it "responds successfully" do
      get :show, params: { id: game.id }
      expect(response).to be_success
    end
  end

  describe "#update" do
    let(:game) { create(:game, name: "foo") }

    it "updates attributes" do
      patch :update, params: { id: game.id, game: { name: "bar" } }
      expect(game.reload.name).to eq("bar")
    end
  end

  describe "#destroy" do
    let!(:game) { create(:game) }

    it "removes a game" do
      expect do
        delete :destroy, params: { id: game.id }
      end.to change(Game, :count).by(-1)
    end

    it "redirects to index" do
      delete :destroy, params: { id: game.id }
      expect(response).to redirect_to(action: :index)
    end

    it "sends a message that everything is ok" do
      delete :destroy, params: { id: game.id }
      expect(flash[:success]).to eq("Game deleted")
    end
  end
end
