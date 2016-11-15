class GamesRepository
  def fetch
    Game.includes(:game_users)
  end
end
