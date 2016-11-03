class BuildTournamentRounds
  attr_reader :tournament
  delegate :teams, :rounds, :game, to: :tournament

  def initialize(tournament)
    @tournament = tournament
  end

  def perform
    build_rounds
    build_matches_in_first_round
  end

  def build_rounds
    number_of_rounds.times do |round_number|
      rounds.build(number: round_number)
    end
  end

  def build_matches_in_first_round
    teams.each_slice(2) do |first_team, second_team|
      rounds.first.matches.build(game: game, team_one: first_team, team_two: second_team)
    end
  end

  def number_of_rounds
    Math.log2(teams.length).to_i
  end
end
