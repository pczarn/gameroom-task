require "rails_helper"

RSpec.describe TeamsController, type: :controller do
  let(:user) { create(:user) }
  before { sign_in(user) }

  describe "#create" do
    subject(:creation) { post :create, params: params }

    context "with valid params" do
      let(:params) { { team: { name: "foo", member_ids: [user.id] } } }

      it "redirects" do
        expect(creation).to be_redirect
      end
    end

    context "with incorrect params" do
      let(:params) { { team: { name: "", member_ids: [user.id] } } }

      it "renders the index" do
        expect(creation).to render_template "teams/index"
      end
    end
  end

  describe "#index" do
    it "responds successfully" do
      get :index
      expect(response).to be_success
    end

    before { create_list(:team, 2) }

    it "assigns a list of teams" do
      get :index
      expect(assigns(:teams)).to all be_a Team
    end
  end

  describe "#edit" do
    subject { get :edit, params: { id: team.id } }
    let(:team) { create(:team) }

    it "responds successfully" do
      is_expected.to be_success
    end
  end

  describe "#update" do
    subject(:updating) { patch :update, params: params }
    let(:team) { create(:team, name: "a", members: [member]) }
    let(:params) { { id: team.id, team: { name: "b" } } }

    context "when a team member is signed in" do
      let(:member) { user }

      context "with valid params" do

        it "updates the name" do
          expect { updating }.to change { team.reload.name }.to eq("b")
        end

        it "redirects" do
          expect(updating).to be_redirect
        end
      end

      context "with incorrect params" do
        let(:params) { { id: team.id, team: { name: "" } } }

        it "gives an alert" do
          expect { updating }.to change { flash.alert }
        end

        it "renders editing" do
          expect(updating).to render_template "teams/edit"
        end
      end
    end

    context "when the logged in user is not a member of the team" do
      let(:member) { create(:user) }

      it "does not update" do
        expect { updating }.not_to change { team.reload.name }
      end

      it "redirects" do
        expect(updating).to be_redirect
      end
    end
  end
end
