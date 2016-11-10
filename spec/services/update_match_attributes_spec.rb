require "rails_helper"

RSpec.describe UpdateMatchAttributes do
  subject(:update_match) { described_class.new(match: match, params: params) }
  let(:match) { create(:match) }
  let(:params) { { team_one_score: 0, team_two_score: 0 } }

  describe "#perform" do
    it "works" do
      expect { update_match.perform }.not_to raise_error
    end
  end
end
