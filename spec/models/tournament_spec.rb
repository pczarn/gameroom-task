require "rails_helper"

RSpec.describe Tournament, type: :model do
  describe "validations" do
    subject { tournament }

    describe "#matches" do
      let(:tournament) { create(:tournament) }

      context "with no matches" do
        before { tournament.matches = [] }

        it { is_expected.not_to be_invalid }
      end

      context "with one match" do
        let(:match) { create(:match) }
        let(:tournament) { build(:tournament, matches: [match]) }

        it { is_expected.to be_valid }

        let(:match) { create(:match, played_at: match_played_at) }

        context "when played before the tournament starts" do
          let(:match_played_at) { tournament.started_at - 1.day }

          it { is_expected.to be_invalid }
        end

        context "when played after the tournament starts" do
          let(:match_played_at) { tournament.started_at + 1.day }

          it { is_expected.to be_valid }
        end
      end
    end

    describe "#title" do
      context "with title not present" do
        let(:tournament) { build(:tournament, title: "") }

        it { is_expected.to be_invalid }
      end

      context "with title present" do
        let(:tournament) { build(:tournament, title: "Test") }

        it { is_expected.to be_valid }
      end

      context "when not unique" do
        let(:title) { "Title" }
        before { create(:tournament, title: title) }
        let(:tournament) { build(:tournament, title: title) }

        it { is_expected.to be_invalid }
      end
    end

    describe "#number_of_teams" do
      let(:tournament) { build(:tournament, number_of_teams: number_of_teams) }

      context "with no teams" do
        let(:number_of_teams) { 0 }

        it { is_expected.to be_invalid }
      end

      context "with one team" do
        let(:number_of_teams) { 1 }

        it { is_expected.to be_invalid }
      end

      context "when even" do
        context "when a power of two" do
          let(:number_of_teams) { 4 }

          it { is_expected.to be_valid }
        end

        context "when not a power of two" do
          let(:number_of_teams) { 6 }

          it { is_expected.to be_invalid }
        end
      end
    end
  end

  describe "#started_at" do
    let(:tournament) { create(:tournament) }

    it "is a time" do
      expect(tournament.started_at).to be_a(Time)
    end
  end
end
