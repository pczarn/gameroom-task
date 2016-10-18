class RoundRepresenter < BaseRepresenter
  attr_reader :round

  def initialize(round)
    @round = round
  end

  def basic
    MatchesRepresenter.new(round.matches)
  end

  def with_number
    {
      number: round.number,
      matches: MatchesRepresenter.new(round.matches),
    }
  end
end
