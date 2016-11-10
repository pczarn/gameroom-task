class GameRepresenter < BaseRepresenter
  attr_reader :game

  def initialize(game)
    @game = game
  end

  def basic
    {
      id: game.id,
      name: game.name,
      archivized: game.archivized?,
      image_url: game.image.url,
      image_thumb_url: game.image.thumb.url,
    }
  end

  def with_stats
    basic.merge(
      stats: game.game_users.order(mean: :desc).map do |game_user|
        GameUserRepresenter.new(game_user).basic
      end,
    )
  end
end
