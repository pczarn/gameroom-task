class TournamentsRepository
  def fetch
    Tournament.all.includes(
      :team_tournaments,
      rounds: :matches,
    )
  end
end
