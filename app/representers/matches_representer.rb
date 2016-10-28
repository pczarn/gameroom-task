class MatchesRepresenter < BaseRepresenter
  attr_reader :matches

  def initialize(matches)
    @matches = matches
  end

  def basic
    matches.map { |match| MatchRepresenter.new(match).basic }
  end

  def with_winner_id
    matches.map { |match| MatchRepresenter.new(match).with_winner_id }
  end

  def with_permissions(current_user)
    matches.map { |match| MatchRepresenter.new(match).with_permissions(current_user) }
  end
end
