module TournamentsHelper
  def potential_teams_for_select(tournament)
    options_for_select(potential_team_names_and_ids(tournament))
  end

  def potential_team_names_and_ids(tournament)
    tournament.potential_teams.pluck(:name, :id)
  end

  def member?(tournament, user)
    members(tournament).exists?(user.id)
  end

  def member_of_team?(team_tournament, user)
    user.team_ids.include?(team_tournament.team_id) &&
      members(team_tournament.tournament).find(user.id)
  end

  def members(tournament)
    @members ||= tournament.members
  end
end
