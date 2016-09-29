class MatchesController < ApplicationController
  include TournamentsHelper

  before_action :authenticate!
  before_action :load_match, only: [:edit, :update, :destroy]
  before_action :ensure_editable!, only: [:edit, :update, :destroy]

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
    render "edit"
  end

  def update
    match_params = @match.round.present? ? match_in_tournament_params : friendly_match_params
    result = FinishMatch.new(@match, match_params).call

    if Rails.application.routes.recognize_path(request.referer)[:controller] == "matches"
      flash.now.alert = result.alert
      render "edit"
    else
      # go back to the source of the update, which can be tournaments/edit, not matches/edit
      flash.alert = result.alert
      redirect_back fallback_location: edit_match_path(@match)
    end
  end

  def destroy
    @match.destroy
    flash.notice = "Match deleted"
    redirect_to action: :index
  end

  private

  def load_match
    @match = Match.friendly.find(params[:id])
  end

  def ensure_editable!
    unless owner?(current_user) || member?(current_user) || current_user.admin?
      redirect_to matches_path, alert: "You must be an owner or a member of a match to edit it."
    end
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

  def owner?(user)
    @match.owner && @match.owner.id == user.id
  end

  def member?(user)
    @match.team_one.member_ids.include?(user.id) || @match.team_two.member_ids.include?(user.id)
  end
end
