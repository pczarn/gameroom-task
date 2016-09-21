module MatchesHelper
  def game_ids_and_names
    Game.active.pluck(:id, :name)
  end

  def team_ids_and_names
    Team.all.pluck(:id, :name)
  end

  def member_names(team_in_match)
    Team.find(team_in_match.id).members.pluck(:name)
  end
end
