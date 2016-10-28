class RoundsRepresenter < BaseRepresenter
  attr_reader :rounds

  def initialize(rounds)
    @rounds = rounds
  end

  def basic
    rounds.map { |round| RoundRepresenter.new(round).basic }
  end

  def with_winner_id
    basic.map(&:with_winner_id)
  end

  def with_permissions(current_user)
    basic.map { |matches| matches.with_permissions(current_user) }
  end
end
