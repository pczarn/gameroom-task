class TournamentPolicy < ApplicationPolicy
  attr_reader :tournament

  def initialize(user, tournament)
    @user = user
    @tournament = tournament
  end

  def update_open?
    tournament.open? && tournament.owner == user
  end

  def update_started?
    tournament.started? && tournament.owner == user
  end

  def create?
    true
  end

  def show?
    true
  end

  def update?
    update_open? || update_started?
  end

  def destroy?
    tournament.owner == user && tournament.open?
  end

  def join?
    tournament.open? && !tournament.members.exists?(user.id)
  end

  def create_team?
    update_open? && !tournament.full?
  end

  def destroy_team?
    update?
  end
end
