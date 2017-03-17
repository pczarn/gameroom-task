class FriendlyMatchesRepository
  def fetch
    Match.friendly.includes(:team_one, :team_two)
  end
end
