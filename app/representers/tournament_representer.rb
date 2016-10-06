class TournamentRepresenter
  attr_reader :round

  def initialize(tournament)
    @tournament = tournament
  end

  def as_json(_ = {})
    {
      id: tournament.id,
      started_at: tournament.started_at,
      image_url: tournament.image.url,
      game: GameRepresenter.new(tournament.game),
      owner: UserRepresenter.new(tournament.owner.id),
      teams: TeamTournamentsRepresenter.new(tournament.team_tournaments).with_teams,
      rounds: RoundsRepresenter.new(tournament.rounds).flat,
    }
  end
end
