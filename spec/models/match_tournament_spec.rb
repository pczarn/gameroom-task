require "rails_helper"

RSpec.describe MatchTournament, type: :model do
  let(:match) { create(:match) }
  let(:tournament) { create(:tournament) }

  describe "relationship" do
    before { create(:match_tournament, match: match, tournament: tournament) }
    let(:built_match_tournament) { build(:match_tournament, match: match, tournament: tournament) }

    it "must be unique" do
      expect { built_match_tournament.valid? }
        .to change { built_match_tournament.errors[:match_id] }.to include("has already been taken")
    end
  end
end
