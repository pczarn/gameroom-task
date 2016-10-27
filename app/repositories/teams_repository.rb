class TeamsRepository
  def teams
    Team.includes(:members)
  end
end
