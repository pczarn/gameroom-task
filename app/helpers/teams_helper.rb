module TeamsHelper
  def potential_members(team)
    User.all - User.joins(:teams).where(teams: { id: team.id })
  end
end
