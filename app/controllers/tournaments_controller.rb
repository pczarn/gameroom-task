class TournamentsController < ApplicationController
  before_action :authenticate!
  before_action :load_tournament, except: [:index, :create]
  before_action :expect_tournament_owner!, only: [:update, :destroy, :add_team, :remove_team]

  def index
    @tournament = Tournament.new(started_at: Time.zone.now)
  end

  def create
    @tournament = current_user.owned_tournaments.build(tournament_params)
    if @tournament.save
      redirect_to edit_tournament_path(@tournament)
    else
      flash.now.alert = @tournament.errors.full_messages.to_sentence
      render "index"
    end
  end

  def edit
    render_editing
  end

  def update
    if @tournament.update(tournament_params)
      redirect_to edit_tournament_path(@tournament)
    else
      render_editing
    end
  end

  def destroy
    unless @tournament.open? && @tournament.destroy
      flash.alert = "Unable to delete the tournament"
    end
    redirect_to tournaments_path
  end

  def add_team
    if @tournament.open?
      team_params = build_team
      @tournament.team_tournaments.build(team_params) if team_params
      unless @tournament.save
        flash.alert = @tournament.errors.full_messages.to_sentence
      end
    end
    redirect_back fallback_location: edit_tournament_path(@tournament)
  end

  def remove_team
    if @tournament.open?
      @tournament.team_tournaments.find_by(team_id: params[:team_id]).destroy!
    end
    redirect_back fallback_location: edit_tournament_path(@tournament)
  end

  private

  def render_editing
    if @tournament.open?
      @team = Team.new
      render "edit"
    else
      render "edit_restricted"
    end
  end

  def load_tournament
    @tournament = Tournament.find(params[:tournament_id] || params[:id])
  end

  def tournament_params
    params.require(:tournament)
          .permit(
            :title,
            :description,
            :game_id,
            :started_at,
            :number_of_teams,
            :number_of_members_per_team,
          )
  end

  def build_team
    if team_id = params[:team_id]
      { team_id: team_id }
    elsif added_or_reused_team.valid?
      { team: added_or_reused_team }
    else
      flash.alert = added_or_reused_team.errors.full_messages.to_sentence
      nil
    end
  end

  def added_or_reused_team
    @added_or_reused_team ||= add_or_reuse_team
  end

  def add_or_reuse_team
    team = Team.new(add_team_params)
    if reused = Team.related_to(team.member_ids).find { |elem| elem.member_ids == team.member_ids }
      flash.notice = "Found a team with these exact members."
      reused
    else
      team
    end
  end

  def add_team_params
    params.require(:team).permit(:name, member_ids: [])
  end

  def expect_tournament_owner!
    return if current_user && @tournament.owned_by?(current_user)
    redirect_back fallback_location: tournaments_path, alert: "You are not the tournament owner."
  end
end
