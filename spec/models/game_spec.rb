require 'rails_helper'

RSpec.describe Game, type: :model do
  let(:game) { create(:game) }

  describe '.name' do
    it 'is a string' do
      expect(game.name).to be_a(String)
    end
  end

  describe 'associations' do
    let(:game) { create(:game_with_matches) }
    it 'includes matches' do
      expect(game.match).not_to be_empty
    end
  end

  describe 'validations' do
    context '.name' do
      let(:game) { build(:game, name: '') }
      it 'is not blank' do
      subject { game }
        is_expected.to be_invalid
      end
    end
  end
end
