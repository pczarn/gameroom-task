class EndTournament
  def initialize(tournament:, match:)
    @tournament = tournament
    @match = match
  end

  def perform
    @tournament.update!(status: :ended)
    TournamentEndWorker.perform_async(@tournament.id, @match.id)
  end
end
