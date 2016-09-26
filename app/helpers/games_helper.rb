module GamesHelper
  def game_path_for_archivize(game)
    game_path(game, game: { state_archivized: "archivized" })
  end

  def game_path_for_activate(game)
    game_path(game, game: { state_archivized: "active" })
  end
end
