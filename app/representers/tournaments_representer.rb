class TournamentsRepresenter < BaseRepresenter
  def initialize(tournaments)
    @tournaments = tournaments
  end

  def as_json(_ = {})
    @tournaments.map { |tournament| TournamentRepresenter.new(tournament) }
  end
end
