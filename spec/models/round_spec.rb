require "rails_helper"

RSpec.describe Round, type: :model do
  describe "validations" do
    subject { built_round }
    let(:round_attrs) { attributes_for(:round) }
    let(:built_round) { build(:round, round_attrs) }

    context "when it is unique" do
      it { is_expected.to be_valid }
    end

    context "when it is duplicate" do
      setup { create(:round, round_attrs) }

      it { is_expected.to be_invalid }
    end
  end
end
