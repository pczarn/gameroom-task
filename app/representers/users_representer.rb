class UsersRepresenter < BaseRepresenter
  def initialize(users)
    @users = users
  end

  def as_json(_ = {})
    @users.map { |user| UserRepresenter.new(user) }
  end
end
