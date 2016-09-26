require "rails_helper"

RSpec.describe GamesController, type: :controller do
  before { sign_in_admin }

  describe "#index" do
    it "responds successfully" do
      get :index
      expect(response).to be_success
    end

    it "responds with html by default" do
      get :index
      expect(response.content_type).to eq "text/html"
    end

    it "assigns a new game" do
      get :index
      expect(assigns(:game)).to be_a(Game)
    end

    describe "list of games" do
      context "with active games" do
        before { create_list(:game, 2) }

        it "has all active games" do
          get :index
          expect(assigns(:active_games).length).to be(2)
        end

        it "does not have any archivized games" do
          get :index
          expect(assigns(:archivized_games).length).to be(0)
        end
      end

      context "with archivized games" do
        before { create_list(:game, 2, state_archivized: "archivized") }

        it "does not have any active games" do
          get :index
          expect(assigns(:active_games).length).to be(0)
        end

        it "has all archivized games" do
          get :index
          expect(assigns(:archivized_games).length).to be(2)
        end
      end
    end
  end

  describe "#create" do
    subject(:creation) { post :create, params: { game: game.attributes } }

    context "with valid data" do
      let(:game) { build(:game) }

      it "succeeds" do
        expect(creation).to redirect_to(edit_game_path(assigns(:game)))
      end

      it "stores a new game" do
        expect { creation }.to change(Game, :count).by(1)
      end
    end

    context "with incorrect data" do
      let(:game) { build(:game, name: "") }

      it "sends an error message" do
        expect { creation }
          .to change { flash.alert }
          .to include("Name can't be blank")
      end

      it "renders the index" do
        expect(creation).to render_template "games/index"
      end
    end

    context "with no image" do
      let(:game) { build(:game, image: nil) }

      it "succeeds" do
        expect(creation).to redirect_to edit_game_path assigns(:game)
      end
    end
  end

  describe "#edit" do
    subject(:edit) { get :edit, params: { id: game.id } }
    let(:game) { create(:game) }

    it "assigns a game" do
      edit
      expect(assigns(:game)).to be_a(Game)
    end

    it "renders editing" do
      expect(edit).to render_template "games/edit"
    end
  end

  describe "#update" do
    subject(:update) { patch :update, params: params }
    let(:params) { { id: game.id, game: { name: "bar" } } }
    let(:game) { create(:game, name: "foo") }

    context "with valid params" do
      it "updates attributes" do
        update
        expect(game.reload.name).to eq(params[:game][:name])
      end

      it "redirects to editing" do
        expect(update).to redirect_to edit_game_path game
      end
    end

    context "with incorrect params" do
      let(:params) { { id: game.id, game: { name: "" } } }

      it "renders editing" do
        expect(update).to render_template "games/edit"
      end
    end
  end

  describe "#destroy" do
    subject(:deletion) { delete :destroy, params: { id: game.id } }
    let!(:game) { create(:game) }

    context "with valid id" do
      it "removes a game" do
        expect { deletion }.to change(Game, :count).by(-1)
      end

      it "redirects to index" do
        expect(deletion).to redirect_to(action: :index)
      end

      it "sends a message that everything is ok" do
        expect { deletion }
          .to change { flash[:success] }
          .to eq("Game deleted")
      end
    end

    context "with incorrect id" do
      subject(:deletion) { delete :destroy, params: { id: 123 } }
      it "fails" do
        expect { deletion }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end
