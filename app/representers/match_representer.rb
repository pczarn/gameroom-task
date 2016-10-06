class MatchRepresenter
  attr_reader :match

  def initialize(match)
    @match = match
  end

  def to_json(_ = {})
    {
      id: match.id,
      played_at: match.played_at,
      team_one: TeamRepresenter.new(match.team_one),
      team_one_score: match.team_one_score,
      team_two: TeamRepresenter.new(match.team_two),
      team_two_score: match.team_two_score,
      owner: match.owner && UserRepresenter.new(match.owner),
    }
  end
end
