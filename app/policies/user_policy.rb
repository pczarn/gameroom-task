class UserPolicy < ApplicationPolicy
  attr_reader :account

  def initialize(user, account)
    @user = user
    @account = account
  end

  def create?
    true
  end

  def update?
    account == user || user && user.admin?
  end
end
