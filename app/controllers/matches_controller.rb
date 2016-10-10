class MatchesController < ApplicationController
  before_action :authenticate!
  after_action :verify_authorized, only: [:edit, :update, :destroy]

  def create
    @match = current_user.owned_matches.build(friendly_match_params)
    if @match.save
      redirect_to edit_match_path(@match)
    else
      flash.now.alert = @match.errors.full_messages.to_sentence
      render "index"
    end
  end

  def index
    @new_match = Match.new(played_at: Time.zone.now)
    @recent = Match.friendly.order(played_at: :desc)
    @recent = @recent.involving(params[:involving_user]) if params[:involving_user]
    @recent = @recent.page(params[:page])
  end

  def edit
    friendly_match
  end

  def update
    match_params = match.round.present? ? match_in_tournament_params : friendly_match_params
    service = FinishMatch.new(match, params: match_params)
    _, alert = service.perform

    if Rails.application.routes.recognize_path(request.referer)[:controller] == "matches"
      flash.now.alert = alert
      render "edit"
    else
      # go back to the source of the update, which can be tournaments/edit, not matches/edit
      flash.alert = alert
      redirect_back fallback_location: edit_match_path(@match)
    end
  end

  def destroy
    friendly_match.destroy
    flash.notice = "Match deleted"
    redirect_to action: :index
  end

  private

  def friendly_match
    @match ||= authorize Match.friendly.find(params[:id])
  end

  def match
    @match ||= authorize Match.find(params[:id])
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
