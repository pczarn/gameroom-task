require "rails_helper"

RSpec.describe Api::V1::UsersController, type: :controller do
  let(:user_attrs) { attributes_for(:user) }
  let(:parsed_body) { JSON.parse(response.body) }

  describe "#create" do
    subject(:creation) { post :create, params: register_params }

    context "with correct confirmation" do
      let(:register_params) { { user: user_attrs } }

      it { is_expected.to be_success }

      it "registers a user" do
        expect { creation }.to change(User, :count).by(1)
      end
    end

    context "with wrong confirmation" do
      let(:register_params) { { user: user_attrs.merge(password_confirmation: "x") } }

      it { is_expected.to be_unprocessable }

      it "responds with an error message" do
        creation
        expect(parsed_body["error"])
          .to include("Password confirmation doesn't match Password")
      end

      it "does not add a user" do
        expect { creation }.not_to change(User, :count)
      end
    end
  end

  describe "#update" do
    subject(:update) { post :update, params: { id: user.id, user: user_attrs } }
    let(:user) { create(:user) }

    context "when the user is logged in" do
      before { sign_in(user) }

      context "with correctly confirmed password" do
        let(:user_attrs) { { password: "blablabla", password_confirmation: "blablabla" } }

        it { is_expected.to be_success }

        it "updates the password" do
          expect { update }.to change { user.reload.password_hashed }
        end
      end

      context "with incorrectly confirmed password" do
        let(:user_attrs) { { password: "blablabla", password_confirmation: "qwertyuio" } }

        it { is_expected.to be_unprocessable }

        it "responds with an error message" do
          update
          expect(parsed_body["error"])
            .to include("Password confirmation doesn't match Password")
        end
      end

      context "with correct name" do
        let(:user_attrs) { { name: "foo" } }

        it { is_expected.to be_success }

        it "updates the account name" do
          expect { update }.to change { user.reload.name }.to eq("foo")
        end
      end

      context "with wrong name" do
        let(:user_attrs) { { name: "" } }

        it { is_expected.to be_unprocessable }

        it "responds with an error message" do
          update
          expect(parsed_body["error"]).to include("Name can't be blank")
        end
      end
    end

    context "when another user is logged in" do
      before { sign_in }

      it { is_expected.to be_forbidden }
    end

    context "when no user is logged in" do
      it { is_expected.to be_unauthorized }
    end
  end
end
