class TournamentRepresenter < BaseRepresenter
  attr_reader :tournament

  def initialize(tournament)
    @tournament = tournament
  end

  def basic
    {
      id: tournament.id,
      title: tournament.title,
      started_at: tournament.started_at,
      status: tournament.status,
      image_url: tournament.image.url,
      number_of_teams: tournament.number_of_teams,
      game_id: tournament.game_id,
      owner_id: tournament.owner_id,
      rounds: RoundsRepresenter.new(tournament.rounds).basic,
      teams: TeamTournamentsRepresenter.new(tournament.team_tournaments).basic,
    }
  end

  def with_permissions(current_user)
    basic.merge(
      rounds: RoundsRepresenter.new(tournament.rounds).with_permissions(current_user),
      editable: TournamentPolicy.new(current_user, tournament).update?,
    )
  end

  def with_teams
    basic.merge(
      teams: TeamTournamentsRepresenter.new(tournament.team_tournaments).with_teams,
    )
  end
end
