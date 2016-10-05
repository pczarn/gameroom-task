class TeamTournamentPolicy < ApplicationPolicy
  attr_reader :team_tournament

  def initialize(user, team_tournament)
    @user = user
    @team_tournament = team_tournament
  end

  def leave?
    !tournament.ended? && team.members.exists?(user.id)
  end

  def remove_member?
    !tournament.ended? && (tournament.owner == user || user.admin?)
  end

  private

  def team
    team_tournament.team
  end

  def tournament
    team_tournament.tournament
  end
end
