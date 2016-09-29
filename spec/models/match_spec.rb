require "rails_helper"

RSpec.describe Match, type: :model do
  let(:teams) { create_list(:team, 2) }
  let(:team_a) { teams[0] }
  let(:team_b) { teams[1] }
  let(:match) { build(:match) }

  describe "#played_at" do
    it "is a time" do
      expect(match.played_at).to be_a(Time)
    end
  end

  describe "validations" do
    subject { match }

    context "#played_at" do
      context "when missing" do
        let(:match) { build(:match, played_at: nil) }
        it { is_expected.to be_valid }
      end

      context "when in a tournament" do
        let(:tournament) do
          build(:tournament, started_at: Time.local(2016).utc, number_of_teams: 2, status: 1)
        end
        let(:round) { build(:round, tournament: tournament) }
        let(:match) { build(:match, round: round, played_at: match_played_at) }

        context "when played after the tournament starts" do
          let(:match_played_at) { Time.local(2017).utc }

          it { is_expected.to be_valid }
        end

        context "when played before the tournament starts" do
          let(:match_played_at) { Time.local(2015).utc }

          it "is invalid" do
            expect { match.valid? }
              .to change { match.errors.messages[:played_at] }
              .to include("Can't be played before the tournament starts")
          end
        end
      end
    end

    context "score" do
      context "when positive" do
        let(:match) { build(:match, team_one_score: 3, team_two_score: 4) }
        it { is_expected.to be_valid }
      end

      context "when negative" do
        let(:match) { build(:match, team_one_score: -666, team_two_score: 3) }
        it "is invalid" do
          expect { match.valid? }
            .to change { match.errors.full_messages }
            .to include("Team one score must be greater than or equal to 0")
        end
      end

      context "when absent" do
        let(:match) { build(:match, :ongoing) }
        it { is_expected.to be_valid }
      end
    end

    context "#no_repeated_members_across_teams" do
      context "teams do not overlap" do
        let(:match) { build(:match, team_one: team_a, team_two: team_b) }
        it { is_expected.to be_valid }
      end

      context "teams have common players" do
        let(:match) { build(:match, team_one: team_a, team_two: team_a) }
        it "is invalid" do
          expect { match.valid? }
            .to change { match.errors[:team_one] }
            .to include("can't have members in common with the other team")
        end
      end
    end
  end

  describe "associations" do
    it "belongs to a game" do
      expect(match.game).to be_a(Game)
    end
  end

  describe "#teams" do
    it "returns two items" do
      expect(match.teams.length).to eq(2)
    end

    it "returns teams" do
      expect(match.teams).to all(be_a(TeamInMatch))
    end
  end

  describe "#teams_in_order" do
    it "returns two items" do
      expect(match.teams.length).to eq(2)
    end

    it "returns teams" do
      expect(match.teams).to all(be_a(TeamInMatch))
    end

    context "when a match has no scores" do
      let(:match) { build(:match, :ongoing) }

      it "maintans the same order" do
        expect(match.teams_in_order).to eq(match.teams)
      end
    end

    context "when a match has only one score" do
      let(:match) { build(:match, team_one_score: nil) }

      it "maintans the same order" do
        expect(match.teams_in_order).to eq(match.teams)
      end
    end

    context "when matches have different scores" do
      context "when the first score is larger" do
        let(:match) { build(:match, team_one_score: 7, team_two_score: 5) }

        it "has the same order" do
          expect(match.teams_in_order).to eq(match.teams)
        end
      end
      context "when the first score is smaller" do
        let(:match) { build(:match, team_one_score: 5, team_two_score: 7) }

        it "has reverse order" do
          expect(match.teams_in_order).to eq(match.teams.reverse)
        end
      end
    end
  end

  describe "#winning_team" do
    it "is the first team in order" do
      expect(match.winning_team).to eq(match.teams_in_order[0])
    end
  end

  describe "#defeated_team" do
    it "is the second team in order" do
      expect(match.defeated_team).to eq(match.teams_in_order[1])
    end
  end
end
