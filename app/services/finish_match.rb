class FinishMatch
  include TournamentsHelper

  attr_reader :alert

  def initialize(match, params)
    @match = match
    @round = match.round
    @tournament = @round && @round.tournament
    @params = params
  end

  def call
    @tournament.with_lock do
      update = @tournament.present? ? update_match_with_tournament : update_match
      update.perform
    end
    @alert = update.alert
  end

  private

  def update_match_with_tournament
    update = update_match
    if !can_edit_tournament?
      update.alert = "You are not permitted to edit the match."
    elsif next_round
      if next_match
        update.alert = "Another match depends on the result of the one you tried to edit."
      elsif match_scores.all?
        update.next_match = build_next_match
      end
    else
      update.end_tournament = true
    end
    update
  end

  def update_match
    UpdateFinishedMatch.new(match: @match, tournament: @tournament, params: @params)
  end

  def can_edit_tournament?
    @current_user && editable?(@match, @current_user) && !@tournament.ended?
  end

  def next_round
    @tournament.rounds[@round.number + 1]
  end

  def next_match
    next_round.matches.find_by(team_one_id: match_team_ids, team_two_id: match_team_ids)
  end

  def match_scores
    [@match.team_one_score, @match.team_two_score]
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

  def initialize(match = nil, tournament = nil, params = nil)
    @match = match
    @tournament = tournament
    @params = params
  end

  def perform
    return if @alert
    update
    send_mails
  end

  private

  def update
    if @match.update(@params)
      @next_match && @next_match.save!
      @end_tournament && @tournament.ended!
    else
      @alert = @match.errors.full_messages.to_sentence
    end
  end

  def send_mails
    if @next_match
      MatchResultMailer.notify_tournament_members(@tournament)
    end

    if @end_tournament
      TournamentResultMailer.result(@tournament, Team.find(@match.winning_team.id))
    end
  end
end
