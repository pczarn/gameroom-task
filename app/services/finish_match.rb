module TournamentRoundAccess
  private

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

class FinishMatch
  include TournamentRoundAccess

  attr_reader :alert

  def initialize(match, params: {})
    @match = match
    @params = params
    @round = match.round
    @tournament = @round && @round.tournament
  end

  def perform
    build_tasks

    Match.transaction do
      begin
        @tasks.save_all
      rescue ActiveModel::ValidationError => error
        @alert = error.model.errors.full_messages.to_sentence
        raise ActiveRecord::Rollback
      end
    end

    @tasks.finish_all unless @alert
  end

  private

  def build_tasks
    @tasks = TaskList.new
    build_update_task
    build_tasks_for_tournament if @tournament
  end

  def build_update_task
    @tasks << UpdateMatch.new(match: @match, params: @params)
  end

  def build_tasks_for_tournament
    if match_scores.all?
      if next_round
        if next_match
          @alert = "Another match depends on the result of the one you tried to edit."
          @tasks.clear
        elsif other_match_in_pair.scores.all?
          @tasks << CreateNextMatch.new(tournament: @tournament, round: @round, match: @match)
        end
      else
        @tasks << EndTournament.new(tournament: @tournament, match: @match)
      end
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
end

class TaskList < Array
  def save_all
    each(&:save)
  end

  def finish_all
    each(&:finish)
  end
end

class UpdateMatch
  def initialize(match:, params:)
    @match = match
    @params = params
  end

  def save
    @match.update!(@params)
  end

  def finish
  end
end

class CreateNextMatch
  include TournamentRoundAccess

  def initialize(tournament:, round:, match:)
    @tournament = tournament
    @round = round
    @match = match
  end

  def save
    build_next_match.save!
  end

  def finish
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
end

class EndTournament
  def initialize(tournament:, match:)
    @tournament = tournament
    @match = match
  end

  def save
    @tournament.update!(status: :ended)
  end

  def finish
    EndTournament.delay.notify_about_tournament_end(@tournament.id, @match.winning_team.id)
  end

  def self.notify_about_tournament_end(tournament_id, winning_team_id)
    tournament = Tournament.find(tournament_id)
    tournament.teams.includes(:members).each do |team|
      team.member_ids.each do |user_id|
        TournamentStatusMailer.notify_about_end(user_id, tournament_id, winning_team_id).deliver
      end
    end
  end
end
