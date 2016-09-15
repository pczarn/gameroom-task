require "rails_helper"

RSpec.describe User, type: :model do
  describe "#admin?" do
    context "with a default role" do
      let(:user) { create(:user) }

      it "returns false" do
        expect(user.admin?).to eq(false)
      end
    end

    context "with a role of 1" do
      let(:user) { create(:user, role: 1) }

      it "returns true" do
        expect(user.admin?).to eq(true)
      end
    end
  end
end
