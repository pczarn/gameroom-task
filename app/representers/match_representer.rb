class MatchRepresenter
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
      winner: match.winning_team.id == match.team_one_id ? 0 : 1,
      owner: match.owner && UserRepresenter.new(match.owner),
    }
  end

  def as_json(_ = {})
    basic.merge(
      team_one: TeamRepresenter.new(match.team_one).shallow,
      team_two: TeamRepresenter.new(match.team_two).shallow,
    )
  end

  def shallow(_ = {})
    basic.merge(
      team_one_id: match.team_one_id,
      team_two_id: match.team_two_id,
    )
  end
end
