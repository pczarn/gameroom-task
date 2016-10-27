class TournamentsRepresenter < BaseRepresenter
  attr_reader :tournaments

  def initialize(tournaments)
    @tournaments = tournaments
  end

  def basic
    tournaments.map { |tournament| TournamentRepresenter.new(tournament).basic }
  end

  def with_teams_and_rounds
    tournaments.map { |tournament| TournamentRepresenter.new(tournament).with_teams_and_rounds }
  end

  def with_permissions(current_user)
    tournaments.map do |tournament|
      TournamentRepresenter.new(tournament).with_permissions(current_user)
    end
  end
end
