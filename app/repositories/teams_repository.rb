class TeamsRepository
  def fetch
    Team.includes(:members)
  end
end
