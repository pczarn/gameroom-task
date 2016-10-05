require "rails_helper"

RSpec.describe TournamentPolicy do
  subject { described_class }
  let(:user) { build(:user) }
  let(:tournament) { build(:tournament) }

  permissions :edit? do
    it { is_expected.to permit(user, tournament) }
  end

  permissions :update_open? do
    context "when user is the tournament owner" do
      context "when tournament is open" do
        let(:tournament) { build(:tournament, owner: user, status: :open) }

        it { is_expected.to permit(user, tournament) }
      end

      context "when tournament is started" do
        let(:tournament) { build(:tournament, owner: user, status: :started) }

        it { is_expected.not_to permit(user, tournament) }
      end

      context "when tournament is ended" do
        let(:tournament) { build(:tournament, owner: user, status: :ended) }

        it { is_expected.not_to permit(user, tournament) }
      end
    end

    context "when user is not the tournament owner" do
      it { is_expected.not_to permit(user, tournament) }
    end
  end

  permissions :update_started? do
    context "when user is the tournament owner" do
      context "when tournament is open" do
        let(:tournament) { build(:tournament, owner: user, status: :open) }

        it { is_expected.not_to permit(user, tournament) }
      end

      context "when tournament is started" do
        let(:tournament) { build(:tournament, owner: user, status: :started) }

        it { is_expected.to permit(user, tournament) }
      end

      context "when tournament is ended" do
        let(:tournament) { build(:tournament, owner: user, status: :ended) }

        it { is_expected.not_to permit(user, tournament) }
      end
    end

    context "when user is not the tournament owner" do
      it { is_expected.not_to permit(user, tournament) }
    end
  end

  permissions :update? do
    context "when #update_open? is permitted" do
      before do
        allow_any_instance_of(described_class).to receive(:update_open?).and_return(true)
      end

      it { is_expected.to permit(user, tournament) }
    end

    context "when #update_started? is permitted" do
      before do
        allow_any_instance_of(described_class).to receive(:update_started?).and_return(true)
      end

      it { is_expected.to permit(user, tournament) }
    end

    context "when updating of open or started tournament is not permitted" do
      it { is_expected.not_to permit(user, tournament) }
    end
  end

  permissions :destroy? do
    context "when user is the tournament owner" do
      let(:tournament) { build(:tournament, owner: user) }

      it { is_expected.to permit(user, tournament) }
    end

    context "when user is not the tournament owner" do
      it { is_expected.not_to permit(user, tournament) }
    end
  end
end
