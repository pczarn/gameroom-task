require "rails_helper"

RSpec.describe Tournament, type: :model do
  let(:tournament) { create(:tournament) }

  describe "validations" do
    subject { tournament }

    describe "#teams" do
      context "with no teams" do
        before { tournament.teams = [] }

        it { is_expected.not_to be_invalid }
      end

      context "with two teams" do
        let(:teams) { create_list(:team, 2) }
        let(:tournament) { build(:tournament, teams: teams) }

        it { is_expected.to be_valid }
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
    it "is a time" do
      expect(tournament.started_at).to be_a(Time)
    end
  end

  describe "#image" do
    it "is present" do
      expect(tournament.image).to be_present
    end
  end
end
