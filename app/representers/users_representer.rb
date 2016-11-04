class UsersRepresenter < BaseRepresenter
  attr_reader :users

  def initialize(users)
    @users = users
  end

  def basic
    users.map { |user| UserRepresenter.new(user).basic }
  end
end
