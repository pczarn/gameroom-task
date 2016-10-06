class GameRepresenter
  attr_reader :game

  def initialize(game)
    @game = game
  end

  def as_json(_ = {})
    {
      name: game.name,
      archivized: game.archivized?,
      image_url: game.image.url,
    }
  end
end
