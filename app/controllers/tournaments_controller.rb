class TournamentsController < ApplicationController
  before_action :authenticate!
  before_action :load_tournament, only: [:edit, :update, :destroy]
  after_action :verify_authorized, only: [:edit, :update, :destroy]

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
    @team = Team.new
  end

  def update
    if @tournament.update(tournament_params)
      redirect_to edit_tournament_path(@tournament)
    else
      @team = Team.new
      render "edit"
    end
  end

  def destroy
    unless @tournament.open? && @tournament.destroy
      flash.alert = "Unable to delete the tournament"
    end
    redirect_to tournaments_path
  end

  private

  def load_tournament
    @tournament = Tournament.find(params[:id])
    authorize @tournament
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
end
