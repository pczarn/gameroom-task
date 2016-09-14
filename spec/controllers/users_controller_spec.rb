require "rails_helper"

RSpec.describe UsersController, type: :controller do
  describe "GET #new" do
    it "returns http success" do
      get :new
      expect(response).to have_http_status(:success)
    end
  end

  let(:user) { build(:user) }
  let(:user_attrs) do
    {
      name: user.name,
      email: user.email,
      password: user.password,
      password_confirmation: user.password,
    }
  end

  describe "#create" do
    subject(:creation) { post :create, params: register_params }

    context "with correct confirmation" do
      let(:register_params) { { user: user_attrs } }

      it "does not give an error message" do
        creation
        expect(assigns(:user).errors.full_messages).to be_empty
      end

      it "redirects to root" do
        is_expected.to redirect_to(root_path)
      end

      it "registers a user" do
        expect { creation }.to change(User, :count).by(1)
      end
    end

    context "with wrong confirmation" do
      let(:register_params) { { user: user_attrs.merge(password_confirmation: "x") } }

      it "fails" do
        creation
        expect(assigns(:user).errors.full_messages)
          .to include("Password confirmation doesn't match Password")
      end

      it "does not add a user" do
        expect { creation }.not_to change(User, :count)
      end
    end
  end
end
