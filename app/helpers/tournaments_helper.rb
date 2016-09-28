module TournamentsHelper
  def potential_teams_for_select(tournament)
    options_for_select(potential_team_names_and_ids(tournament))
  end

  def potential_team_names_and_ids(tournament)
    tournament.potential_teams.pluck(:name, :id)
  end

  def editable?(match, user)
    user.admin? || scores_not_set?(match) && owned_by?(match, user)
  end

  def scores_not_set?(match)
    match.team_one_score.nil? || match.team_two_score.nil?
  end

  def owned_by?(match, user)
    match.round.tournament.owner.id == user.id ||
      match.team_one.member_ids.include?(user.id) ||
      match.team_two.member_ids.include?(user.id)
  end
end
