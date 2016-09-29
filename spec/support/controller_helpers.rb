module ControllerHelpers
  def sign_in(user = build(:user))
    @user = user
    allow(controller).to receive(:authenticate!)
    allow(controller).to receive(:current_user).and_return(user)
  end

  def sign_in_admin(user = build(:user))
    allow(user).to receive(:admin?).and_return(true)
    allow(controller).to receive(:authenticate!)
    allow(controller).to receive(:current_user).and_return(user)
  end
end
