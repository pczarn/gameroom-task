class TeamTournamentsRepresenter < BaseRepresenter
  attr_reader :team_tournaments

  def initialize(team_tournaments)
    @team_tournaments = team_tournaments
  end

  def basic
    team_tournaments.map { |elem| TeamTournamentRepresenter.new(elem).basic }
  end

  def with_teams
    team_tournaments.map { |elem| TeamTournamentRepresenter.new(elem).with_team }
  end
end
