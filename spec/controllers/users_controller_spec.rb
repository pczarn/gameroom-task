require "rails_helper"

RSpec.describe UsersController, type: :controller do
  describe "GET #new" do
    it "returns http success" do
      get :new
      expect(response).to have_http_status(:success)
    end
  end

  let(:user_attrs) { attributes_for(:user) }

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

  describe "#update" do
    subject(:update) { post :update, params: { id: user.id, user: user_attrs } }
    let!(:user) { create(:user) }

    context "when the user is logged in" do
      before { sign_in(user) }

      context "with password correctly confirmed" do
        let(:user_attrs) { { password: "blablabla", password_confirmation: "blablabla" } }

        it "does not give an error message" do
          update
          expect(assigns(:user).errors).to be_empty
        end

        it "redirects to editing" do
          is_expected.to redirect_to(edit_user_path(user))
        end

        it "updates the password" do
          expect { update }.to change { user.reload.password_hashed }
        end
      end

      context "with password incorrectly confirmed" do
        let(:user_attrs) { { password: "blablabla", password_confirmation: "qwertyuio" } }

        it "fails" do
          update
          expect(assigns(:user).errors.full_messages)
            .to include("Password confirmation doesn't match Password")
        end
      end

      context "with correct name" do
        let(:user_attrs) { { name: "foo" } }

        it "does not give an error message" do
          update
          expect(assigns(:user).errors).to be_empty
        end

        it "redirects to editing" do
          is_expected.to redirect_to(edit_user_path(user))
        end

        it "updates the account name" do
          expect { update }.to change { user.reload.name }.to eq("foo")
        end
      end

      context "with wrong name" do
        let(:user_attrs) { { name: "" } }

        it "fails" do
          update
          expect(assigns(:user).errors.full_messages).to include("Name can't be blank")
        end
      end
    end

    context "when another user is logged in" do
      it "fails" do
        expect(controller).not_to receive(:update)
        update
      end

      it "redirects to root" do
        expect(update).to redirect_to(root_path)
      end
    end
  end
end
