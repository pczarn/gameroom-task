class FinishMatch
  include TournamentsHelper

  def initialize(match, current_user: nil, params: {})
    @match = match
    @params = params
    @round = match.round
    @tournament = @round && @round.tournament
    @current_user = current_user
  end

  def perform
    build_tasks

    Match.transaction do
      @tasks.save_all
    end

    @tasks.finish_all
  end

  def alert
    @tasks.alert
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
    if !can_edit_tournament?
      @tasks << Alert.new("You are not permitted to edit the match.")
    elsif next_round
      if next_match
        @tasks << Alert.new("Another match depends on the result of the one you tried to edit.")
      elsif match_scores.all?
        @tasks << CreateNextMatch.new(tournament: @tournament, round: @round, match: @match)
      end
    else
      @tasks << EndTournament.new(tournament: @tournament, match: @match)
    end
  end

  def can_edit_tournament?
    @current_user && editable?(@match, @current_user) && !@tournament.ended?
  end

  def next_round
    @tournament.rounds[@round.number + 1]
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
    each do |task|
      task.save or break
    end
  end

  def finish_all
    each(&:finish)
  end

  def alert
    map { |task| task.alert }.find { |alert| alert.present? }
  end
end

class UpdateMatch
  def initialize(match:, params:)
    @match = match
    @params = params
  end

  def save
    @match.update(@params)
  end

  def finish
  end

  def alert
    @match.errors.full_messages.to_sentence unless @match.errors.empty?
  end
end

class CreateNextMatch
  def initialize(tournament:, round:, match:)
    @tournament = tournament
    @round = round
    @match = match
  end

  def save
    build_next_match.save!
    true
  end

  def finish
    CreateNextMatch.delay.notify_about_match_result(@match.id)
  end

  def alert
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

  def other_match_in_pair
    @round.matches[index_in_round ^ 1]
  end

  def index_in_round
    @round.matches.find_index(@match)
  end
end

class EndTournament
  def initialize(tournament:, match:)
    @tournament = tournament
    @match = match
  end

  def save
    @tournament.update!(status: :ended)
    true
  end

  def finish
    EndTournament.delay.notify_about_tournament_end(@tournament.id, @match.winning_team.id)
  end

  def alert
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

class Alert
  attr_reader :alert

  def initialize(alert)
    @alert = alert
  end

  def save
    true
  end

  def finish
  end
end
