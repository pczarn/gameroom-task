class GamesRepresenter
  def initialize(games)
    @games = games
  end

  def as_json(_ = {})
    @games.map { |game| GameRepresenter.new(game) }
  end
end
