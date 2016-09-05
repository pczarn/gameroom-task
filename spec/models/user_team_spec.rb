require 'rails_helper'

# should this go to team_spec?
RSpec.describe UserTeam, type: :model do
  let(:player) { create(:user) }
  let(:team) { create(:team) }

  subject { user_team_b }

  describe 'relationship' do
    let!(:user_team_a) { create(:user_team, user: player, team: team) }
    let(:user_team_b) { build(:user_team, user: player, team: team) }

    it 'must be unique' do
      expect { subject.valid? }.to change { subject.errors[:user_id] }.to include('has already been taken')
    end
  end
end
