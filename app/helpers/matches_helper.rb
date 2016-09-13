module MatchesHelper
  def game_ids_and_names
    Game.all.pluck(:id, :name)
  end

  def team_ids_and_names
    Team.all.pluck(:id, :name)
  end
end
