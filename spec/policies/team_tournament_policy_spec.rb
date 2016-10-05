require "rails_helper"

RSpec.describe TeamTournamentPolicy do
  subject { described_class }
  let(:user) { build(:user) }
  let(:team_tournament) { build(:team_tournament) }

  permissions :leave? do
    context "when tournament is not ended" do
      context "when user is a member of the team" do
        let(:team) { create(:team, members: [user]) }
        let(:team_tournament) { build(:team_tournament, team: team) }

        it { is_expected.to permit(user, team_tournament) }
      end

      context "when user is not a member of the team" do
        it { is_expected.not_to permit(user, team_tournament) }
      end
    end

    context "when tournament is ended" do
      it { is_expected.not_to permit(user, team_tournament) }
    end
  end

  permissions :remove_member? do
    context "when tournament is not ended" do
      context "when user is the owner of the tournament" do
        before do
          team_tournament.tournament.owner = user
        end

        it { is_expected.to permit(user, team_tournament) }
      end

      context "when user is an admin" do
        let(:user) { build(:user, role: :admin) }

        it { is_expected.to permit(user, team_tournament) }
      end

      context "when user is not an admin or the owner of the tournament" do
        it { is_expected.not_to permit(user, team_tournament) }
      end
    end

    context "when tournament is ended" do
      it { is_expected.not_to permit(user, team_tournament) }
    end
  end
end
