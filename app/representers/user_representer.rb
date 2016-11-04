class UserRepresenter < BaseRepresenter
  attr_reader :user

  def initialize(user)
    @user = user
  end

  def basic
    {
      id: user.id,
      name: user.name,
      email: user.email,
      role: user.role,
    }
  end
end
