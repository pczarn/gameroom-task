module ControllerHelpers
  def sign_in(user = double("user"))
    allow(controller).to receive(:authenticate!)
    allow(controller).to receive(:current_user).and_return(user)
  end
end
