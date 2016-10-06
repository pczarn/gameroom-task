class UserRepresenter
  attr_reader :user

  def initialize(user)
    @user = user
  end

  def as_json(_ = {})
    {
      id: user.id,
      name: user.name,
      email: user.email,
      avatar_url: user.image.url,
      role: user.role,
    }
  end
end
