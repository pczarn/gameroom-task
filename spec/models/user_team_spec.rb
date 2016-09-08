require "rails_helper"

# should this go to team_spec?
RSpec.describe UserTeam, type: :model do
  let(:player) { create(:user) }
  let(:team) { create(:team) }

  describe "relationship" do
    before { create(:user_team, user: player, team: team) }
    let(:user_team_b) { build(:user_team, user: player, team: team) }

    it "must be unique" do
      expect { user_team_b.valid? }
        .to change { user_team_b.errors[:user_id] }.to include("has already been taken")
    end
  end
end
