class MatchesController < ApplicationController
  include TournamentsHelper

  before_action :authenticate!
  before_action :load_match, only: [:edit, :update, :destroy]

  def create
    @match = Match.new(friendly_match_params)
    if @match.save
      redirect_to edit_match_path(@match)
    else
      flash[:error] = @match.errors.full_messages
      render "index"
    end
  end

  def index
    @new_match = Match.new(played_at: Time.zone.now)
    @recent = Match.order(played_at: :desc)
    @recent = @recent.involving(params[:involving_user]) if params[:involving_user]
    @recent = @recent.page(params[:page])
  end

  def edit
  end

  def update
    if @match.round
      tournament = @match.round.tournament
      round_number = @match.round.number
      if next_round = tournament.rounds[round_number + 1]
        team_ids = [@match.team_one_id, @match.team_two_id]
        if next_round.matches.find_by(team_one_id: team_ids, team_two_id: team_ids)
          redirect_back alert: "Another match depends on the result of the one you tried to edit.",
                        fallback_location: edit_match_path(@match)
          return
        end
      end
      unless current_user && editable?(@match, current_user) && !tournament.ended?
        redirect_back alert: "You are not permitted to edit the match.",
                      fallback_location: edit_match_path(@match)
        return
      end
      match_params = match_in_tournament_params
    else
      match_params = friendly_match_params
    end

    if @match.update(match_params)
      round = @match.round
      tournament = round && round.tournament
      if tournament && @match.team_one_score && @match.team_two_score
        if next_round = tournament.rounds[round.number + 1]
          index_in_round = @match.round.matches.find_index(@match)
          other_match_in_pair = @match.round.matches[index_in_round ^ 1]
          # TODO: perhaps set the order of team one and two?
          # TODO: when the result is a tie?
          next_round.matches.create(
            game: tournament.game,
            team_one_id: @match.winning_team.id,
            team_two_id: other_match_in_pair.winning_team.id,
          )
          MatchResultMailer.notify_tournament_members(tournament)
        else
          TournamentResultMailer.result(tournament, Team.find(@match.winning_team.id))
          tournament.ended!
        end
      end
      redirect_back fallback_location: edit_match_path(@match)
    elsif Rails.application.routes.recognize_path(request.referer)[:controller] == "matches"
      flash.now.alert = @match.errors.full_messages.to_sentence
      render "edit"
    else
      # go back to the source of the update, which is tournaments/edit, not matches/edit
      flash.alert = @match.errors.full_messages.to_sentence
      redirect_back fallback_location: edit_match_path(@match)
    end
  end

  def destroy
    @match.destroy
    flash[:success] = "Match deleted"
    redirect_to action: :index
  end

  private

  def load_match
    @match = Match.find(params[:id])
  end

  def match_in_tournament_params
    params.require(:match).permit(
      :played_at,
      :team_one_score,
      :team_two_score,
    )
  end

  def friendly_match_params
    params.require(:match).permit(
      :played_at,
      :game_id,
      :team_one_id,
      :team_two_id,
      :team_one_score,
      :team_two_score,
    )
  end
end
