class TournamentsRepository
  def fetch
    Tournament.all.includes(
      :team_tournaments,
      rounds: {
        matches: [:team_one, :team_two],
      },
    )
  end
end
