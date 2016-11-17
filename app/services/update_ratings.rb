require "saulabs/trueskill"

class UpdateRatings
  include Saulabs::TrueSkill

  def initialize(match:, scores:)
    @match = match
    @scores = scores
  end

  def perform
    score_diff = @scores[0].to_i - @scores[1].to_i
    team_one_stats = team_members_and_stats(@match.game, @match.team_one)
    team_two_stats = team_members_and_stats(@match.game, @match.team_two)
    team_one = team_ratings(team_one_stats)
    team_two = team_ratings(team_two_stats)
    graph = ScoreBasedBayesianRating.new(team_one => score_diff, team_two => -score_diff)
    graph.update_skills
    update_stats(team_one_stats, team_one)
    update_stats(team_two_stats, team_two)
  end

  private

  def team_members_and_stats(game, team)
    team.members.includes(:game_users).map do |member|
      [member, member.game_users.find_by(game: game)]
    end
  end

  def team_ratings(stats)
    stats.map do |_, stat|
      if stat
        Rating.new(stat.mean, stat.deviation)
      else
        Rating.new(25.0, 25.0 / 3)
      end
    end
  end

  def update_stats(stats, ratings)
    stats.zip(ratings) do |(member, stat), rating|
      params = { mean: rating.mean, deviation: rating.deviation }
      if stat
        stat.update!(params)
      else
        member.game_users.create!(game: @match.game, **params)
      end
    end
  end
end
