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
    teams_in_first_round.each_slice(2) do |first_team, second_team|
      rounds[0].matches.build(game: game, team_one: first_team, team_two: second_team)
    end
    teams_in_second_round.each_slice(2) do |first_team, second_team|
      rounds[1].matches.build(game: game, team_one: first_team, team_two: second_team)
    end
  end

  def number_of_rounds
    Math.log2(teams.length).ceil
  end

  def teams_in_first_round
    teams[0, number_of_teams_in_first_round]
  end

  def teams_in_second_round
    teams[number_of_teams_in_first_round, number_of_teams_in_second_round]
  end

  def number_of_teams_in_first_round
    lower_power_of_two = 2**Math.log2(teams.length).floor
    if lower_power_of_two == teams.length
      lower_power_of_two
    else
      (teams.length - lower_power_of_two) * 2
    end
  end

  def number_of_teams_in_second_round
    if teams.length.even?
      teams.length - number_of_teams_in_first_round
    else
      teams.length - number_of_teams_in_first_round - 1
    end
  end
end
