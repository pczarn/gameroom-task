class UsersRepository
  def users
    User.all.select(:id, :name, :email, :role)
  end
end
