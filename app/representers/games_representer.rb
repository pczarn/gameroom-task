class GamesRepresenter < BaseRepresenter
  def initialize(games)
    @games = games
  end

  def basic
    @games.map { |game| GameRepresenter.new(game) }
  end

  def with_stats
    @games.map { |game| GameRepresenter.new(game).with_stats }
  end
end
