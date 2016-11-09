class UpdateMatch
  def initialize(match, params: {})
    @match = match
    @params = params
    @round = match.round
    @tournament = @round && @round.tournament
  end

  def perform
    if match_scores.all? && @tournament && next_round && next_match
      return false, "Another match depends on the result of the one you tried to edit."
    end
    Match.transaction { tasks.each(&:perform) }
  end

  private

  def tasks
    if @tasks.nil?
      @tasks = [task_for_match_update]
      @tasks.push(*tasks_for_tournament) if @tournament
    end
    @tasks
  end

  def task_for_match_update
    UpdateMatchAttributes.new(match: @match, params: @params)
  end

  def tasks_for_tournament
    return [] unless match_scores.all?
    if next_round
      if other_match_in_pair.scores.all?
        [CreateNextMatch.new(tournament: @tournament, round: @round, match: @match)]
      else
        []
      end
    else
      [EndTournament.new(tournament: @tournament, match: @match)]
    end
  end

  def match_scores
    @params.values_at(:team_one_score, :team_two_score)
  end

  def next_match
    next_round.matches.find_by(team_one_id: team_ids, team_two_id: team_ids)
  end

  def team_ids
    [@match.team_one_id, @match.team_two_id]
  end

  def next_round
    @tournament.rounds[@round.number + 1]
  end

  def other_match_in_pair
    @round.matches[index_in_round ^ 1]
  end

  def index_in_round
    @round.matches.find_index(@match)
  end
end
