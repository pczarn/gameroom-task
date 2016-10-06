class RoundsRepresenter
  attr_reader :rounds

  def initialize(rounds)
    @rounds = rounds
  end

  def flat
    rounds.sort_by(&:number).map(&:matches).map { |round| RoundRepresenter.new(round) }
  end

  def as_json(_ = {})
    rounds.map { |round| RoundRepresenter.new(round) }
  end
end
