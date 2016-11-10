class CreateNextMatch
  def initialize(tournament:, round:, match:)
    @tournament = tournament
    @round = round
    @match = match
  end

  def perform
    build_next_match.save!
    CreateNextMatch.delay.notify_about_match_result(@match.id)
  end

  def self.notify_about_match_result(match_id)
    User.pluck(:id).each do |user_id|
      TournamentStatusMailer.notify_about_match_result(user_id, match_id).deliver
    end
  end

  private

  def build_next_match
    team_one, team_two = next_match_teams
    next_round.matches.build(
      game: @tournament.game,
      team_one_id: team_one.id,
      team_two_id: team_two.id,
    )
  end

  def next_match_teams
    [@match.winning_team, other_match_in_pair.winning_team]
  end

  def next_round
    @tournament.rounds[@round.number + 1]
  end

  def other_team_in_next_match
    if other_match_in_pair
      other_match_in_pair.winning_team if other_match_in_pair.scores.all?
    else
      @tournament.teams[(index_in_round + 1) * 2]
    end
  end

  def other_match_in_pair
    @other_match_in_pair ||= @round.matches[index_in_round ^ 1]
  end

  def index_in_round
    @round.matches.find_index(@match)
  end
end
