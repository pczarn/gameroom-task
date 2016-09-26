require "rails_helper"

RSpec.describe TeamsController, type: :controller do
  let(:owner) { create(:user) }
  before { sign_in(owner) }

  describe "#create" do
    subject(:creation) { post :create, params: params }

    context "with valid params" do
      let(:params) { { team: { name: "foo" } } }

      it "redirects" do
        expect(creation).to be_redirect
      end
    end

    context "with incorrect params" do
      let(:params) { { team: { name: "" } } }

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
  end

  describe "#edit" do
    subject { get :edit, params: { id: team.id } }
    let(:team) { create(:team) }

    it "responds successfully" do
      is_expected.to be_success
    end
  end

  describe "#update" do
    subject(:updating) { patch :update, params: { id: team.id, team: { name: "b" } } }
    let(:team) { create(:team, name: "a") }
    before { team.user_teams << create(:user_team, user: owner, team: team, role: :owner) }

    it "updates the name" do
      expect { updating }.to change { team.reload.name }.to eq("b")
    end
  end

  describe "#destroy" do
    subject(:destruction) { delete :destroy, params: { id: team.id } }
    let!(:team) { create(:team) }

    context "when the current user owns the team" do
      before { team.user_teams << create(:user_team, user: owner, team: team, role: :owner) }

      it "removes a team" do
        expect { destruction }.to change(Team, :count).by(-1)
      end
    end

    context "when the current user does not own the team" do
      it "does not remove a team" do
        expect { destruction }.not_to change(Team, :count)
      end

      it "gives an alert" do
        expect { destruction }.to change { flash.alert }
      end
    end
  end

  describe "#add_member" do
    subject(:add_member) { post :add_member, params: { team_id: team.id, member_id: user.id } }
    let(:team) { create(:team) }
    let(:user) { create(:user) }

    context "when the current user owns the team" do
      before { team.user_teams << create(:user_team, user: owner, team: team, role: :owner) }

      it "adds a member" do
        expect { add_member }.to change { team.reload.member_ids }.to include(user.id)
      end
    end

    context "when the current user does not own the team" do
      it "does not add a member" do
        expect { add_member }.not_to change { team.reload.member_ids }
      end

      it "gives an alert" do
        expect { add_member }.to change { flash.alert }
      end
    end
  end

  describe "#remove_member" do
    subject(:remove_member) do
      post :remove_member, params: { team_id: team.id, member_id: user.id }
    end

    before { team.user_teams.find_by(user: owner).owner! }

    context "when removing a member other than the owner" do
      let(:team) { create(:team, members: [user, owner]) }
      let(:user) { create(:user) }

      it "removes the member" do
        expect { remove_member }.to change { team.reload.members.count }.by(-1)
      end
    end

    context "when removing the only owner" do
      let(:team) { create(:team, members: [owner]) }
      let(:user) { owner }

      it "gives an alert" do
        expect { remove_member }
          .to change { flash.alert }
          .to("Cannot remove the only owner from a team")
      end
    end
  end
end
