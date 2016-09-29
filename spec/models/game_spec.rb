require "rails_helper"

RSpec.describe Game, type: :model do
  describe "#name" do
    let(:game) { create(:game) }

    it "is a string" do
      expect(game.name).to be_a(String)
    end
  end

  describe "#image" do
    let(:game) { create(:game, :with_image) }

    it "is present" do
      expect(game.image).to be_present
    end
  end

  describe "validations" do
    context "#name" do
      subject { built_game }

      context "when missing" do
        let(:built_game) { build(:game, name: "") }

        it { is_expected.to be_invalid }
      end

      context "when not unique" do
        before { create(:game, name: "our_game") }
        let(:built_game) { build(:game, name: "our_game") }

        it { is_expected.to be_invalid }
      end
    end
  end
end
