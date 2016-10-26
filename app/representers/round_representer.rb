class RoundRepresenter < BaseRepresenter
  attr_reader :round

  def initialize(round)
    @round = round
  end

  def as_json(_ = {})
    {
      number: round.number,
      # number_of_matches: round.number_of_matches,
      matches: MatchesRepresenter.new(round.matches),
    }
  end
end
