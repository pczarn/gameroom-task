class TeamTournamentPolicy < ApplicationPolicy
  attr_reader :team_tournament

  def initialize(user, team_tournament)
    @user = user
    @team_tournament = team_tournament
  end

  def create?
    TournamentPolicy.new(@user, tournament).create_team?
  end

  def destroy?
    TournamentPolicy.new(@user, tournament).destroy_team?
  end

  def update?
    !tournament.ended? && (tournament.owner == user || user.admin?)
  end

  def leave?
    !tournament.ended?
  end

  private

  def tournament
    team_tournament.tournament
  end
end
