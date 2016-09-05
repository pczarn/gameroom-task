require 'rails_helper'

RSpec.describe Match, type: :model do
  let(:user_teams) { create_list(:user_team, 2) }
  let(:team_a) { user_teams[0].team }
  let(:team_b) { user_teams[1].team }
  let(:match) { build(:match, team_one_score: 3) }

  subject { match }

  describe 'score' do
    it 'is present' do
      expect(subject.team_one_score).to eq(3)
    end

    context 'ongoing match' do
      let(:match) { build(:ongoing_match) }
      it 'is absent' do
        expect(subject.team_one_score).to be_nil
      end
    end
  end

  describe '.played_at' do
    it 'is time' do
      expect(subject.played_at).to be_a(Time)
    end
  end

  context 'with valid data' do
    context '.no_repeated_player_in_different_teams' do
      let(:match) { build(:match, team_one: team_a, team_two: team_b) }
      it 'can have teams with distinct players' do
        expect { subject.valid? }.not_to change { subject.errors.messages }
      end
    end
  end

  describe 'validations' do
    context '.played_at' do
      let(:match) { build(:match, played_at: nil) }
      it 'is not missing' do
        expect(subject).to be_invalid
      end
    end

    context '.teams_not_empty' do
      let(:match) { build(:match, team_one: nil) }
      it 'neither of the teams can empty' do
        expect { subject.valid? }.to change { subject.errors[:team_one] }.to include("Can't be empty")
      end
    end

    context '.no_repeated_player_in_different_teams' do
      let(:match) { build(:match, team_one: team_a, team_two: team_a) }
      # TODO check if this line is really needed
      # subject { match } ?????
      it 'cannot have common players' do
        expect { subject.valid? }.to change { subject.errors[:team_one] }.to include("Can't have players in both teams")
      end
    end
  end
end
