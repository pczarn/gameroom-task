require "rails_helper"

RSpec.describe Match, type: :model do
  let(:teams) { create_list(:team_with_members, 2) }
  let(:team_a) { teams[0] }
  let(:team_b) { teams[1] }

  describe "score" do
    let(:match) { build(:match, team_one_score: 3) }
    it "is present" do
      expect(match.team_one_score).to eq(3)
    end

    context "ongoing match" do
      let(:match) { build(:ongoing_match) }
      it "is absent" do
        expect(match.team_one_score).to be_nil
      end
    end
  end

  describe ".played_at" do
    let(:match) { build(:match) }
    it "is a time" do
      expect(match.played_at).to be_a(Time)
    end
  end

  describe "validations" do
    context ".played_at" do
      context "when missing" do
        let(:match) { build(:match, played_at: nil) }
        it "is invalid" do
          expect(match).to be_invalid
        end
      end
    end

    context "score" do
      let(:match) { build(:match, team_one_score: -666, team_two_score: 3) }
      it "must be positive" do
        expect(match).to be_invalid
      end
    end

    context ".teams_not_empty" do
      let(:match) { build(:match, team_one: nil) }
      it "neither of the teams can empty" do
        expect { match.valid? }
          .to change { match.errors[:team_one] }.to include("Can't be empty")
      end
    end

    context ".no_repeated_members_across_teams" do
      let(:match) { build(:match, team_one: team_a, team_two: team_b) }
      it "can have teams with distinct players" do
        expect(match).to be_valid
      end

      let(:match) { build(:match, team_one: team_a, team_two: team_a) }
      it "cannot have common players" do
        expect { match.valid? }
          .to change { match.errors[:team_one] }
          .to include("Can't have common members in both teams")
      end
    end
  end

  describe "associations" do
    let(:match) { build(:match) }
    it "belongs to a game" do
      expect(match.game).to be_a(Game)
    end
  end
end
