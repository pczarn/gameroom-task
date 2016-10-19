class FriendlyMatchesRepository
  def friendly_matches
    Match.friendly.order(played_at: :desc)
  end
end
