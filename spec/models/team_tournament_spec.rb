require "rails_helper"

RSpec.describe TeamTournament, type: :model do
  let(:team) { create(:team) }
  let(:tournament) { create(:tournament) }

  describe "relationship" do
    before { create(:team_tournament, team: team, tournament: tournament) }
    let(:built_team_tournament) { build(:team_tournament, team: team, tournament: tournament) }

    it "must be unique" do
      expect { built_team_tournament.valid? }
        .to change { built_team_tournament.errors[:team_id] }.to include("has already been taken")
    end
  end
end
