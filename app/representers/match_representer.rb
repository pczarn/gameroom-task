class MatchRepresenter < BaseRepresenter
  attr_reader :match

  def initialize(match)
    @match = match
  end

  def basic
    {
      id: match.id,
      game_id: match.game_id,
      played_at: match.played_at,
      team_one_score: match.team_one_score,
      team_two_score: match.team_two_score,
      team_one_id: match.team_one_id,
      team_two_id: match.team_two_id,
      owner_id: match.owner_id,
    }
  end

  def with_winner
    basic.merge(
      winner: match.winning_team.id == match.team_one_id ? 0 : 1,
    )
  end

  def with_permissions(current_user)
    with_winner.merge(
      editable: MatchPolicy.new(current_user, match).update?,
    )
  end

  def with_teams
    basic.merge(
      team_one: TeamRepresenter.new(match.team_one).basic,
      team_two: TeamRepresenter.new(match.team_two).basic,
    )
  end
end
