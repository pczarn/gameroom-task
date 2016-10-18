class TournamentsRepresenter < BaseRepresenter
  attr_reader :tournaments

  def initialize(tournaments)
    @tournaments = tournaments
  end

  def basic
    tournaments.map { |tournament| TournamentRepresenter.new(tournament).basic }
  end

  def with_permissions(current_user)
    basic.map { |tournament| tournament.with_permissions(current_user) }
  end
end
