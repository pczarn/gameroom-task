class GameRepresenter
  attr_reader :game

  def initialize(game)
    @game = game
  end

  def as_json(_ = {})
    {
      id: game.id,
      name: game.name,
      archivized: game.archivized?,
      image_url: game.image.url,
      image_thumb_url: game.image.thumb.url,
    }
  end
end
