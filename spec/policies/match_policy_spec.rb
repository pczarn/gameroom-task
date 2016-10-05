require "rails_helper"

RSpec.describe MatchPolicy do
  subject { described_class }
  let(:user) { build(:user) }

  permissions :update?, :destroy? do
    context "when in a tournament" do
      let(:tournament) { build(:tournament, :with_rounds) }
      let(:match) { build(:match) }
      before do
        tournament.rounds.first.matches << match
      end

      context "when match has score set" do
        it { is_expected.not_to permit(user, match) }
      end

      context "when match does not have the score" do
        let(:match) { build(:match, :ongoing) }

        context "when user is an admin" do
          let(:user) { build(:user, role: :admin) }

          it { is_expected.to permit(user, match) }
        end

        context "when user participates in the match" do
          context "when user is in team one" do
            before do
              match.team_one.members << user
            end

            it { is_expected.to permit(user, match) }
          end

          context "when user is in team two" do
            before do
              match.team_two.members << user
            end

            it { is_expected.to permit(user, match) }
          end
        end

        context "when user owns the tournament" do
          let(:tournament) { build(:tournament, :with_rounds, owner: user) }

          it { is_expected.to permit(user, match) }
        end

        context "when user is not an admin and not related to the match" do
          it { is_expected.not_to permit(user, match) }
        end
      end
    end

    context "when match is friendly" do
      let(:match) { build(:match) }

      context "when user is an admin" do
        let(:user) { build(:user, role: :admin) }

        it { is_expected.to permit(user, match) }
      end

      context "when user is the match owner" do
        let(:match) { build(:match, owner: user) }

        it { is_expected.to permit(user, match) }
      end

      context "when user is not an admin and not the match owner" do
        it { is_expected.not_to permit(user, match) }
      end
    end
  end
end
