require "rails_helper"

RSpec.describe TeamsHelper, type: :helper do
  describe "#potential_member_ids_and_names" do
    let(:team) { build(:team) }

    context "with the user not in the team" do
      before { create(:user) }

      it "returns a potential user" do
        expect(potential_member_ids_and_names(team).size).to eq(1)
      end
    end

    context "with the user in the team" do
      let(:user) { create(:user) }

      before do
        team.members << user
        team.save!
      end

      it "returns no potential users" do
        expect(potential_member_ids_and_names(team).size).to eq(0)
      end
    end
  end
end
