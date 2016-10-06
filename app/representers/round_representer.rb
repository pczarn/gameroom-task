class RoundRepresenter
  attr_reader :round

  def initialize(round)
    @round = round
  end

  def as_json(_ = {})
    {
      number: round.number,
      matches: MatchesRepresenter.new(round.matches),
    }
  end
end
