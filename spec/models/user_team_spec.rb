require "rails_helper"

# should this go to team_spec?
RSpec.describe UserTeam, type: :model do
  let(:player) { create(:user) }
  let(:team) { create(:team) }

  describe "relationship" do
    before { create(:user_team, user: player, team: team) }
    let(:built_user_team) { build(:user_team, user: player, team: team) }

    it "must be unique" do
      expect { built_user_team.valid? }
        .to change { built_user_team.errors[:user_id] }.to include("has already been taken")
    end
  end
end
