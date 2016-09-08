require 'rails_helper'

RSpec.describe Team, type: :model do
  let(:player) { create(:user) }
  let(:second_player) { create(:user) }
  let(:third_player) { create(:user) }
  let(:fourth_player) { create(:user) }

  describe '.unique_user_collections_for_teams' do
    context 'when collections are equal' do
      before { create(:team, users: [player]) }
      let(:team_b) { build(:team, users: [player]) }
      it 'cannot pass validation' do
        expect { team_b.valid? }.to change { team_b.errors[:users] }.to include("Teams with these exact users exist")
      end
    end

    subject { team_b }

    context "when collections are not equal" do
      before { create(:team, users: [player, second_player]) }
      context "when collections overlap" do
        context "when one collection is contained in another" do
          let(:team_b) { build(:team, users: [player, second_player, third_player]) }
          it 'is valid' do
            is_expected.to be_valid
          end
        end

        context 'when one collection does not contain another' do
          let(:team_b) { build(:team, users: [second_player, third_player]) }
          it 'is valid' do
            is_expected.to be_valid
          end
        end
      end

      context 'when collections do not overlap' do
        let(:team_b) { build(:team, users: [third_player, fourth_player]) }
        it 'is valid' do
          is_expected.to be_valid
        end
      end
    end
  end
end
