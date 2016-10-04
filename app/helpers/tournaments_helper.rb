module TournamentsHelper
  def can_join?(user, tournament)
    tournament.open? && !member?(user, tournament)
  end

  def can_leave?(user, team_tournament)
    !team_tournament.tournament.ended? && member_of_team?(user, team_tournament)
  end

  def can_edit_team_tournament?(user, team_tournament)
    !team_tournament.tournament.ended? &&
      (
        team_tournament.tournament.owned_by?(user) ||
        user.admin?
      )
  end

  def can_remove_user_from_team_tournament?(current_user, user, team_tournament)
    can_leave?(user, team_tournament) &&
      (
        current_user.id == user.id ||
        can_edit_team_tournament?(current_user, team_tournament)
      )
  end

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

  def member?(user, tournament)
    members(tournament).exists?(user.id)
  end

  def member_of_team?(user, team_tournament)
    user.team_ids.include?(team_tournament.team_id) &&
      members(team_tournament.tournament).find(user.id)
  end

  def members(tournament)
    @members ||= tournament.members
  end
end
