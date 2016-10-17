require "rails_helper"

RSpec.describe Api::V1::TeamTournamentParticipationsController, type: :controller do
  let(:current_user) { create(:user) }
  before { sign_in(current_user) }

  describe "#create" do
    subject(:adding) { post :create, params: params }
    let(:tournament) { create(:tournament, owner: current_user) }
    let(:members) { create_list(:user, 3) }
    let(:params) { { tournament_id: tournament.id, team: team_params } }
    let(:team_params) { { name: "foo", member_ids: members.pluck(:id) } }

    context "when the tournament is open" do
      context "when adding a unique team" do
        it { is_expected.to be_success }

        it "adds the team" do
          expect { adding }.to change { tournament.teams.count }.by(1)
        end
      end

      context "when adding a duplicate team" do
        before { create(:team, name: "bar", members: members) }

        it { is_expected.to be_success }

        it "adds a reused the team" do
          expect { adding }
            .to change { tournament.reload.teams.pluck(:name) }
            .to include("bar")
        end
      end
    end

    context "when the tournament is not open" do
      before { tournament.started! }

      it { is_expected.to be_forbidden }
    end
  end

  describe "#destroy" do
    subject(:removing) { post :destroy, params: params }
    let(:params) { { id: team_tournament.id } }
    let(:team_tournament) { create(:team_tournament) }

    let(:tournament) do
      create(:tournament, team_tournaments: [team_tournament], owner: current_user)
    end

    context "when the tournament is open" do
      it "removes the team" do
        expect { removing }.to change { tournament.teams.count }.by(-1)
      end
    end

    context "when the tournament is not open" do
      before { tournament.started! }

      it { is_expected.to be_forbidden }
    end
  end
end
