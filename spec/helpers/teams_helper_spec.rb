require "rails_helper"

RSpec.describe TeamsHelper, type: :helper do
  describe "joining_user_ids_and_names" do
    let(:team) { build(:team) }

    context "with the user not in the team" do
      before { create(:user) }

      it { expect(joining_user_ids_and_names(team).size).to eq(1) }
    end

    context "with the user in the team" do
      let(:user) { create(:user) }

      before do
        team.members << user
        team.save!
      end

      it { expect(joining_user_ids_and_names(team).size).to eq(0) }
    end
  end
end
