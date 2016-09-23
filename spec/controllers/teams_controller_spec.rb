require "rails_helper"

RSpec.describe TeamsController, type: :controller do
  describe "#create" do
    subject { post :create, params: params }

    context "with valid params" do
      let(:params) { { name: "foo" } }

      it "redirects" do
        is_expected.to redirect
      end
    end

    context "with incorrect params" do
      let(:params) { { name: "" } }
      it "renders the index" do
        is_expected.to render_template "teams/index"
      end
    end
  end
end
