class TournamentsController < ApplicationController
  before_action :authenticate!
  before_action :load_tournament, only: [:edit, :update, :destroy, :add_team, :remove_team]
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
    if @tournament.open?
      @team = Team.new
      render "edit"
    else
      render "edit_restricted"
    end
  end

  def update
    if @tournament.update(tournament_params)
      redirect_to edit_tournament_path(@tournament)
    elsif @tournament.open?
      @team = Team.new
      render "edit"
    else
      render "edit_restricted"
    end
  end

  def destroy
    unless @tournament.open? && @tournament.destroy
      flash.alert = "Unable to delete the tournament"
    end
    redirect_to tournaments_path
  end

  def add_team
    if team_id = params[:team_id]
      @tournament.team_tournaments.build(team_id: team_id)
    else
      team = Team.new(add_team_params)
      if found = Team.related_to(team.member_ids).find { |elem| elem.member_ids == team.member_ids }
        team = found
        flash.notice = "Found a team with these exact members."
      end
      if team.valid?
        @tournament.team_tournaments.build(team: team)
      else
        flash.alert = team.errors.full_messages.to_sentence
      end
    end

    unless @tournament.save
      flash.alert = @tournament.errors.full_messages.to_sentence
    end

    redirect_back fallback_location: edit_tournament_path(@tournament)
  end

  def remove_team
    @tournament.team_tournaments.find_by(team_id: params[:team_id]).destroy!
    redirect_back fallback_location: edit_tournament_path(@tournament)
  end

  private

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

  def add_team_params
    params.require(:team).permit(:name, member_ids: [])
  end

  def expect_tournament_owner!
    return if current_user && @tournament.owned_by?(current_user)
    redirect_back fallback_location: tournaments_path, alert: "You are not the tournament owner."
  end
end
