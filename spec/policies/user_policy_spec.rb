require "rails_helper"

RSpec.describe UserPolicy do
  subject { described_class }
  let(:user) { User.new }

  permissions :update?, :edit? do
    it "allows access when user is an admin" do
      is_expected.to permit(User.new(role: :admin), user)
    end

    it "allows users to update their own accounts" do
      is_expected.to permit(user, user)
    end

    it "denies access when user is not an admin and not an owner of the account" do
      is_expected.not_to permit(User.new, user)
    end
  end
end
