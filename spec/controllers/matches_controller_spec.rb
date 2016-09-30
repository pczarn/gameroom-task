require "rails_helper"

shared_examples_for "an action that modifies matches" do
  context "when the user owns the match" do
    it "performs the action" do
      expect(controller).to receive(action_name)
      action
    end
  end

  context "when the user participates in the match" do
    before do
      match.team_one.members << current_user
      match.owner = nil
      match.save!
    end

    it "performs the action" do
      expect(controller).to receive(action_name)
      action
    end
  end

  context "when the user is an admin" do
    let(:current_user) { build(:user, role: :admin) }
    before { match.update(owner: nil) }

    it "performs the action" do
      expect(controller).to receive(action_name)
      action
    end
  end

  context "when the user has no access" do
    before { match.update(owner: nil) }

    it "does not perform the action" do
      expect(controller).not_to receive(action_name)
      action
    end

    it "redirects" do
      is_expected.to be_redirect
    end

    it "gives an alert" do
      expect { action }.to change { flash.alert }
    end
  end
end

RSpec.describe MatchesController, type: :controller do
  let(:current_user) { build(:user) }

  before do
    sign_in(current_user)
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
    subject(:action) { get :edit, params: { id: match.id } }
    let(:action_name) { :edit }
    let(:match) { create(:match, owner: current_user) }

    it "ensures the user can edit the match" do
      expect(controller).to receive(:ensure_editable!)
      action
    end

    it "responds successfully" do
      is_expected.to be_success
    end

    it_behaves_like "an action that modifies matches"
  end

  describe "#update" do
    subject(:action) { patch :update, params: { id: match.id, match: { team_one_score: 2 } } }
    let(:action_name) { :update }
    let(:match) { create(:match, team_one_score: 1, owner: current_user) }

    it "ensures the user can edit the match" do
      expect(controller).to receive(:ensure_editable!)
      action
    end

    it "updates attributes" do
      expect { action }.to change { match.reload.team_one_score }.to eq(2)
    end

    it "calls a service to finish the match" do
      service = instance_double(FinishMatch)
      allow(FinishMatch).to receive(:new).and_return(service)
      allow(service).to receive(:alert)
      expect(service).to receive(:call)
      action
    end

    it_behaves_like "an action that modifies matches"
  end

  describe "#destroy" do
    subject(:action) { delete :destroy, params: { id: match.id } }
    let(:action_name) { :destroy }
    let!(:match) { create(:match, owner: current_user) }

    it "ensures the user can edit the match" do
      expect(controller).to receive(:ensure_editable!)
      action
    end

    it "removes a match" do
      expect { action }.to change(Match, :count).by(-1)
    end

    it "redirects to index" do
      is_expected.to redirect_to(action: :index)
    end

    it "gives a message that everything is ok" do
      expect { action }.to change { flash.notice }.to include("Match deleted")
    end

    it_behaves_like "an action that modifies matches"
  end
end
