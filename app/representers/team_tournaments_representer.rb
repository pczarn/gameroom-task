class TeamTournamentsRepresenter
  attr_reader :team_tournaments

  def initialize(team_tournaments)
    @team_tournaments = team_tournaments
  end

  def with_teams(_ = {})
    team_tournaments.map { |elem| TeamTournamentRepresenter.new(elem).with_team }
  end
end
