require "rails_helper"

RSpec.describe Api::V1::TeamsController, type: :controller do
  let(:user) { create(:user) }
  before { sign_in(user) }

  let(:parsed_body) { JSON.parse(response.body) }

  describe "#create" do
    subject(:creation) { post :create, params: params }

    context "with valid params" do
      let(:params) { { team: { name: "foo", member_ids: [user.id] } } }

      it { is_expected.to be_success }

      it "responds with json" do
        expect(creation.content_type).to eq "application/json"
      end
    end

    context "with incorrect params" do
      let(:params) { { team: { name: "", member_ids: [user.id] } } }

      it { is_expected.to be_unprocessable }
    end
  end

  describe "#index" do
    subject(:get_index) { get :index }

    it { is_expected.to be_success }

    context "with saved teams" do
      before { create_list(:team, 2) }

      it "responds with a list of teams" do
        get_index
        expect(parsed_body.length).to eq(2)
      end
    end
  end

  describe "#show" do
    subject { get :show, params: { id: team.id } }
    let(:team) { create(:team) }

    it { is_expected.to be_success }
  end

  describe "#update" do
    subject(:updating) { patch :update, params: params }
    let(:team) { create(:team, name: "a", members: [member]) }
    let(:params) { { id: team.id, team: { name: "b" } } }

    context "when a team member is signed in" do
      let(:member) { user }

      context "with valid params" do
        it { is_expected.to be_success }

        it "updates the name" do
          expect { updating }.to change { team.reload.name }.to eq("b")
        end
      end

      context "with incorrect params" do
        let(:params) { { id: team.id, team: { name: "" } } }

        it { is_expected.to be_unprocessable }
      end
    end

    context "when the logged in user is not a member of the team" do
      let(:member) { create(:user) }

      it { is_expected.to be_forbidden }
    end
  end
end
