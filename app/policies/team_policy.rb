class TeamPolicy < ApplicationPolicy
  attr_reader :team

  def initialize(user, team)
    @user = user
    @team = team
  end

  def show?
    true
  end

  def update?
    team.members.include?(@user) || @user.admin?
  end
end
