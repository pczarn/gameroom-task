class CreateTournamentLineup
  def initialize(tournament:, team: nil, params: nil)
    @tournament = tournament
    @team = team
    @params = params
  end

  def team_tournament
    @team_tournament ||= @tournament.team_tournaments.build(team: team)
  end

  def perform
    team_tournament
    @tournament.save!
  end

  private

  def team
    @team ||= CreateOrReuseTeam.new(@params).perform
  end
end
