require "rails_helper"

RSpec.describe SessionsController, type: :controller do
  describe "GET #new" do
    it "returns http success" do
      get :new
      expect(response).to have_http_status(:success)
    end
  end

  let(:user) { create(:user) }
  let(:login_params) { { email: user.email, password: user.password } }

  describe "#create" do
    subject(:creation) { post :create, params: login_params }

    context "with correct params" do
      it "succeeds" do
        expect { creation }.to change { session[:user_id] }.to eq(user.id)
      end

      it "redirects to root" do
        is_expected.to redirect_to(root_path)
      end

      it "gives a notice" do
        expect { creation }.to change { flash.notice }.to include("You are logged in")
      end
    end

    context "with wrong params" do
      let(:login_params) { { email: user.email, password: "x" } }

      it "does not log in" do
        expect { creation }.not_to change { session[:user_id] }
      end

      it "gives an alert" do
        expect { creation }.to change { flash.alert }.to include("Invalid email or password")
      end
    end
  end

  describe "#destroy" do
    before { post :create, params: login_params }
    subject(:destruction) { post :destroy }

    it "logs out" do
      expect { destruction }.to change { session[:user_id] }.to be_nil
    end

    it "gives a notice" do
      expect { destruction }.to change { flash.notice }.to include("Logged out")
    end

    it "redirects to root" do
      is_expected.to redirect_to(root_path)
    end
  end
end
