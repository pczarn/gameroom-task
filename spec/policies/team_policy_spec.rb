require "rails_helper"

RSpec.describe TeamPolicy do
  subject { described_class }
  let(:user) { User.new }
  let(:team) { Team.new }

  permissions :show? do
    it { is_expected.to permit(user, team) }
  end

  permissions :update? do
    context "when user is a member of the team" do
      let(:team) { build(:team, members: [user]) }

      it { is_expected.to permit(user, team) }
    end

    context "when user is an admin" do
      let(:user) { build(:user, role: :admin) }

      it { is_expected.to permit(user, team) }
    end

    context "when user is not a member of the team and not an admin" do
      it { is_expected.not_to permit(user, team) }
    end
  end
end
