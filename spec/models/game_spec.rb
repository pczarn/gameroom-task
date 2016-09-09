require "rails_helper"

RSpec.describe Game, type: :model do
  let(:game) { create(:game_with_matches) }

  describe ".name" do
    it "is a string" do
      expect(game.name).to be_a(String)
    end
  end

  describe ".image" do
    it "is present" do
      expect(game.image).to be_present
    end
  end

  describe "validations" do
    context ".name" do
      subject { built_game }

      context "when missing" do
        let(:built_game) { build(:game, name: "") }
        it { is_expected.to be_invalid }
      end

      before { create(:game, name: "our_game") }
      let(:built_game) { build(:game, name: "our_game") }
      context "when not unique" do
        it { is_expected.to be_invalid }
      end
    end
  end
end
