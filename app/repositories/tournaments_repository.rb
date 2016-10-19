class TournamentsRepository
  def tournaments
    Tournament.all.includes(
      :team_tournaments,
      rounds: :matches,
    )
  end
end
