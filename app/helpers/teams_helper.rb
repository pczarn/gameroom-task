module TeamsHelper
  def potential_member_ids_and_names(team)
    User.pluck(:id, :name) - User.joins(:teams).where(teams: { id: team.id }).pluck(:id, :name)
  end
end
