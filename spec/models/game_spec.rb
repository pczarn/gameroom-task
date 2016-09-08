require "rails_helper"

RSpec.describe Game, type: :model do
  let(:game) { create(:game_with_matches) }

  describe ".name" do
    it "is a string" do
      expect(game.name).to be_a(String)
    end
  end

  describe "associations" do
    it "includes matches" do
      expect(game.match).not_to be_empty
    end
  end

  describe "validations" do
    context ".name" do
      subject { built_game }
      before { create(:game, name: "our_game") }

      let(:built_game) { build(:game, name: "") }
      it "is present" do
        is_expected.to be_invalid
      end

      let(:built_game) { build(:game, name: "our_game") }
      it "must be unique" do
        is_expected.to be_invalid
      end
    end
  end
end
