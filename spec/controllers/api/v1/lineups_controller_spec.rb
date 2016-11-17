require "rails_helper"

RSpec.describe Api::V1::LineupsController, type: :controller do
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
    subject(:removing) { delete :destroy, params: params }
    let(:params) { { tournament_id: team_tournament.tournament.id, id: team_tournament.team.id } }
    let(:team_tournament) { create(:team_tournament) }

    let(:tournament) do
      create(:tournament, team_tournaments: [team_tournament], owner: current_user)
    end

    context "when the tournament is open" do
      it "removes the team" do
        expect { removing }.to change { tournament.teams.count }.by(-1)
      end
    end

    context "when the tournament is started" do
      before { tournament.started! }

      it "removes the team" do
        expect { removing }.to change { tournament.teams.count }.by(-1)
      end
    end

    context "when the tournament is ended" do
      before { tournament.ended! }

      it { is_expected.to be_forbidden }
    end
  end

  describe "#update" do
    subject(:updating) { patch :update, params: params }
    let(:team) { create(:team, members_count: 5) }
    let(:set_member_ids) { team.member_ids[0, 3] }

    let(:params) do
      {
        tournament_id: tournament.id,
        id: team.id,
        team: {
          name: "lightning",
          member_ids: set_member_ids,
        },
      }
    end

    let(:tournament) do
      create(:tournament, teams: [team], owner: tournament_owner)
    end

    let(:tournament_owner) { current_user }

    context "when the tournament is open" do
      let(:service) { instance_double(ReplaceTournamentLineup) }

      context "when the current user owns the tournament" do
        it "uses a service to update the team" do
          allow(ReplaceTournamentLineup).to receive(:new).and_return(service)
          expect(service).to receive(:perform) { build(:team) }
          updating
        end

        context "when a team with such members does not exist yet" do
          it { is_expected.to be_success }

          it "updates the team" do
            expect { updating }
              .to change { tournament.reload.teams.first.member_ids.sort }
              .to eq(set_member_ids.sort)
          end
        end

        context "when a team with such members already exists" do
          before { create(:team, name: "bar", member_ids: set_member_ids) }

          it { is_expected.to be_success }

          it "uses a service to update the team" do
            allow(ReplaceTournamentLineup).to receive(:new).and_return(service)
            expect(service).to receive(:perform) { build(:team) }
            updating
          end

          it "adds a reused the team" do
            expect { updating }
              .to change { tournament.reload.teams.pluck(:name) }
              .to include("bar")
          end
        end
      end

      context "when the current user does not own the tournament" do
        let(:tournament_owner) { build(:user) }

        context "when joining a team" do
          let(:set_member_ids) { team.member_ids + [current_user.id] }

          it { is_expected.to be_success }

          it "uses a service to update the team" do
            allow(ReplaceTournamentLineup).to receive(:new).and_return(service)
            expect(service).to receive(:perform) { build(:team) }
            updating
          end

          it "adds the current user to the team" do
            expect { updating }
              .to change { tournament.reload.teams.first.member_ids }
              .to include(current_user.id)
          end
        end

        context "when leaving a team" do
          let(:another_user) { create(:user) }
          let(:team) { create(:team, members: [current_user, another_user]) }
          let(:set_member_ids) { [another_user.id] }

          it { is_expected.to be_success }

          it "uses a service to update the team" do
            allow(ReplaceTournamentLineup).to receive(:new).and_return(service)
            expect(service).to receive(:perform) { build(:team) }
            updating
          end

          it "removes the current user from the team" do
            expect { updating }
              .to change { tournament.reload.teams.first.member_ids }
              .to eq(set_member_ids)
          end
        end

        context "when the current user is a member of the tournament" do
          before { team.members << current_user }

          context "when adding or removing other users" do
            it { is_expected.to be_forbidden }
          end
        end

        context "when the current user is not a member of the tournament" do
          context "when adding or removing other users" do
            it { is_expected.to be_forbidden }
          end

          context "when not adding or removing any users" do
            let(:set_member_ids) { team.member_ids }

            it { is_expected.to be_forbidden }
          end
        end
      end
    end

    context "when the tournament is ended" do
      before { tournament.ended! }

      it { is_expected.to be_forbidden }
    end

    context "when in a friendly match" do
      let(:match) { create(:match, team_one: team, owner: match_owner) }
      let(:match_owner) { current_user }

      let(:service) { instance_double(ReplaceFriendlyMatchLineup) }

      let(:params) do
        {
          friendly_match_id: match.id,
          id: team.id,
          team: {
            name: "lightning",
            member_ids: set_member_ids,
          },
        }
      end

      context "when the current user owns the match" do
        it { is_expected.to be_success }

        it "uses a service to update the team" do
          allow(ReplaceFriendlyMatchLineup).to receive(:new).and_return(service)
          expect(service).to receive(:perform) { build(:team) }
          updating
        end
      end

      context "when the current user does not own the match" do
        let(:match_owner) { build(:user) }

        context "when joining a team" do
          let(:set_member_ids) { team.member_ids + [current_user.id] }

          it { is_expected.to be_success }

          it "uses a service to update the team" do
            allow(ReplaceFriendlyMatchLineup).to receive(:new).and_return(service)
            expect(service).to receive(:perform) { build(:team) }
            updating
          end
        end

        context "when leaving a team" do
          let(:another_user) { create(:user) }
          let(:team) { create(:team, members: [current_user, another_user]) }
          let(:set_member_ids) { [another_user.id] }

          it { is_expected.to be_success }

          it "uses a service to update the team" do
            allow(ReplaceFriendlyMatchLineup).to receive(:new).and_return(service)
            expect(service).to receive(:perform) { build(:team) }
            updating
          end

          it "removes the current user from the team" do
            expect { updating }
              .to change { match.reload.team_one.member_ids }
              .to eq(set_member_ids)
          end
        end

        context "when the current user is a member of the tournament" do
          before { team.members << current_user }

          context "when adding or removing other users" do
            it { is_expected.to be_success }
          end
        end

        context "when the current user does not participate in the match" do
          context "when adding or removing other users" do
            it { is_expected.to be_forbidden }
          end

          context "when not adding or removing any users" do
            let(:set_member_ids) { team.member_ids }

            it { is_expected.to be_forbidden }
          end
        end
      end
    end
  end
end
