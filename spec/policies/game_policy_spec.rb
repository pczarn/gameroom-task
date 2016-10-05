require "rails_helper"

RSpec.describe GamePolicy do
  subject { described_class }
  let(:user) { User.new }

  permissions :create?, :update?, :destroy? do
    it "allows access when user is an admin" do
      is_expected.to permit(User.new(role: :admin), Game.new)
    end

    it "denies access when user is not an admin" do
      is_expected.not_to permit(user, Game.new)
    end
  end
end
