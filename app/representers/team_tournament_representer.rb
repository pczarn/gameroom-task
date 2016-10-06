class TeamTournamentRepresenter
  attr_reader :round

  def initialize(team_tournament)
    @team_tournament = team_tournament
  end

  def with_team(_ = {})
    {
      id: team_tournament.id,
      team_size_limit: team_tournament.team_size_limit,
      team: TeamRepresenter.new(team_tournament.team),
    }
  end
end
