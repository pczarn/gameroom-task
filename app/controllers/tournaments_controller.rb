class TournamentsController < ApplicationController
  before_action :authenticate!
  before_action :expect_tournament_owner!, only: [:add_team, :remove_team]
  before_action :load_tournament, only: [:edit, :update]

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
      render "edit"
    else
      render "edit_restricted"
    end
  end

  def update
    if @tournament.update(tournament_params)
      redirect_to edit_tournament_path(@tournament)
    elsif @tournament.open?
      render "edit"
    else
      render "edit_restricted"
    end
  end

  def add_team
    @tournament = Tournament.find(params[:tournament_id])
    if member_id = params[:member_id]
      member = User.find(member_id)
      team = Team.create(name: member.name, members: [member])
      @tournament.team_tournaments.build team_id: team.id
    elsif team_id = params[:team_id]
      @tournament.team_tournaments.build team_id: team_id
    else
      flash.alert = "Invalid parameters"
    end

    unless @tournament.save
      flash.alert = @tournament.errors.full_messages.to_sentence
    end

    redirect_back fallback_location: edit_tournament_path(@tournament)
  end

  def remove_team
    @tournament = Tournament.find(params[:tournament_id])
    team_id = params[:team_id]
    @tournament.team_tournaments.find_by(team_id: team_id).destroy!
    redirect_back fallback_location: @tournament
  end

  private

  def load_tournament
    @tournament = Tournament.find(params[:id])
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

  def expect_tournament_owner!
    return if current_user && Tournament.find(params[:tournament_id]).owned_by?(current_user)
    redirect_back fallback_location: teams_path, alert: "You are not the tournament owner."
  end
end
