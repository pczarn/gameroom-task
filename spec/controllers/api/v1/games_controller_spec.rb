require "rails_helper"

RSpec.describe Api::V1::GamesController, type: :controller do
  before { sign_in_admin }

  let(:parsed_body) { JSON.parse(response.body) }

  describe "#index" do
    it "responds successfully" do
      get :index
      expect(response).to be_success
    end

    it "responds with json by default" do
      get :index
      expect(response.content_type).to eq "application/json"
    end

    describe "list of games" do
      before { create_list(:game, 2) }

      it "has all games" do
        get :index
        expect(parsed_body.length).to eq(2)
      end
    end
  end

  describe "#create" do
    subject(:creation) { post :create, params: { game: game.attributes } }

    context "with valid data" do
      let(:game) { build(:game) }

      specify { expect(creation).to be_success }

      it "stores a new game" do
        expect { creation }.to change(Game, :count).by(1)
      end
    end

    context "with incorrect data" do
      let(:game) { build(:game, name: "") }

      it "responds with the code for unprocessable entity" do
        expect(creation).to be_unprocessable
      end
    end

    context "with no image" do
      let(:game) { build(:game, image: nil) }

      specify { expect(creation).to be_success }
    end
  end

  describe "#show" do
    subject(:show) { get :show, params: { id: game.id } }
    let(:game) { create(:game) }

    specify { expect(show).to be_success }

    it "responds with json" do
      expect(show.content_type).to eq "application/json"
    end
  end

  describe "#update" do
    subject(:update) { patch :update, params: params }
    let(:params) { { id: game.id, game: { name: "bar" } } }
    let(:game) { create(:game, name: "foo") }

    context "with valid params" do
      specify { expect(update).to be_success }

      it "responds with json" do
        expect(update.content_type).to eq "application/json"
      end

      it "updates attributes" do
        expect { update }.to change { game.reload.name }.to eq(params[:game][:name])
      end
    end

    context "with incorrect params" do
      let(:params) { { id: game.id, game: { name: "" } } }

      it "responds with the code for unprocessable entity" do
        expect(update).to be_unprocessable
      end
    end
  end

  describe "#destroy" do
    subject(:deletion) { delete :destroy, params: { id: game.id } }
    let!(:game) { create(:game) }

    context "with valid id" do
      specify { expect(deletion).to be_success }

      it "removes a game" do
        expect { deletion }.to change(Game, :count).by(-1)
      end
    end

    context "with incorrect id" do
      subject(:deletion) { delete :destroy, params: { id: 123 } }

      it "fails" do
        expect(deletion).to be_not_found
      end
    end
  end
end
