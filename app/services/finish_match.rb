class FinishMatch
  include TournamentsHelper

  def initialize(match, current_user: nil, params: nil, update: nil)
    @match = match
    @round = match.round
    @tournament = @round && @round.tournament
    @current_user = current_user
    @update = update
    @update ||= UpdateFinishedMatch.new(match: match, tournament: @tournament, params: params)
  end

  def call
    update_with_tournament if @tournament.present?
    @update.perform
  end

  def alert
    @update.alert
  end

  private

  def update_with_tournament
    if !can_edit_tournament?
      @update.alert = "You are not permitted to edit the match."
    elsif next_round
      if next_match
        @update.alert = "Another match depends on the result of the one you tried to edit."
      elsif match_scores.all?
        @update.next_match = build_next_match
      end
    else
      @update.end_tournament = true
    end
  end

  def can_edit_tournament?
    @current_user && editable?(@match, @current_user) && !@tournament.ended?
  end

  def next_round
    @tournament.rounds[@round.number + 1]
  end

  def next_match
    next_round.matches.find_by(team_one_id: team_ids, team_two_id: team_ids)
  end

  def match_scores
    @update.params.values_at(:team_one_score, :team_two_score)
  end

  def build_next_match
    team_one, team_two = next_match_teams
    next_round.matches.build(
      game: @tournament.game,
      team_one_id: team_one.id,
      team_two_id: team_two.id,
    )
  end

  def team_ids
    [@match.team_one_id, @match.team_two_id]
  end

  def next_match_teams
    [@match.winning_team, other_match_in_pair.winning_team]
  end

  def other_match_in_pair
    @round.matches[index_in_round ^ 1]
  end

  def index_in_round
    @round.matches.find_index(@match)
  end
end

class UpdateFinishedMatch
  attr_accessor :alert, :next_match, :end_tournament
  attr_reader :params

  def initialize(match:, tournament:, params:)
    @match = match
    @tournament = tournament
    @params = params
  end

  def perform
    return if @alert
    transactional_update
    send_mails
  end

  def self.notify_about_match_result(match_id)
    User.pluck(:id).each do |user_id|
      TournamentStatusMailer.notify_about_match_result(user_id, match_id).deliver
    end
  end

  def self.notify_about_tournament_end(tournament_id, winning_team_id)
    tournament = Tournament.find(tournament_id)
    tournament.teams.includes(:members).each do |team|
      team.member_ids.each do |user_id|
        TournamentStatusMailer.notify_about_end(user_id, tournament_id, winning_team_id).deliver
      end
    end
  end

  private

  def transactional_update
    if @tournament
      @tournament.with_lock { update unless @tournament.ended? }
    else
      Match.transaction { update }
    end
  end

  def update
    if @match.update(@params)
      @next_match.save! if @next_match
      @tournament.update!(status: :ended) if @end_tournament
    else
      @alert = @match.errors.full_messages.to_sentence
    end
  end

  def send_mails
    if @next_match
      UpdateFinishedMatch.delay.notify_about_match_result(@match.id)
    end

    if @end_tournament
      UpdateFinishedMatch.delay.notify_about_tournament_end(@tournament.id, @match.winning_team.id)
    end
  end
end
