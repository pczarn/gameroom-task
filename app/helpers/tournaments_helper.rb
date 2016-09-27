module TournamentsHelper
  def potential_teams_for_select(tournament)
    options_for_select(potential_team_names_and_ids(tournament))
  end

  def potential_team_names_and_ids(tournament)
    tournament.potential_teams.pluck(:name, :id)
  end
end
