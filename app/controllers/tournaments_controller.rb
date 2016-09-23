class TournamentsController < ApplicationController
  before_action :authenticate!
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
end
