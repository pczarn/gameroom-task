class GamesRepository
  def games
    Game.all.select(:id, :name, :state_archivized, :image)
  end
end
