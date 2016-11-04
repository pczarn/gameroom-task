module ControllerHelpers
  def sign_in(user = create(:user))
    token = Knock::AuthToken.new(payload: { sub: user.id }).token
    request.env["HTTP_AUTHORIZATION"] = "Bearer #{token}"
  end

  def sign_in_admin(user = create(:user))
    user.update!(role: :admin)
    sign_in(user)
  end
end
