class TournamentRepresenter
  attr_reader :tournament

  def initialize(tournament)
    @tournament = tournament
  end

  def basic(_ = {})
    {
      id: tournament.id,
      title: tournament.title,
      started_at: tournament.started_at,
      status: tournament.status,
      image_url: tournament.image.url,
      number_of_teams: tournament.number_of_teams,
      game: GameRepresenter.new(tournament.game),
      owner: UserRepresenter.new(tournament.owner),
      rounds: RoundsRepresenter.new(tournament.rounds).flat,
    }
  end

  def shallow(_ = {})
    basic.merge(
      teams: TeamTournamentsRepresenter.new(tournament.team_tournaments).shallow,
    )
  end

  def as_json(_ = {})
    basic.merge(
      teams: TeamTournamentsRepresenter.new(tournament.team_tournaments).with_teams,
      # teams_info: teams_info,
      # rounds_info: rounds_info,
      # winning_team: winning_team,
    )
  end

  # def teams_info
  #   if tournament.open?
  #     tournament.team_tournaments.map { |tt| [tt.team.members.size, tt.number_of_slots] }
  #   end
  # end
end
