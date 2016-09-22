class TournamentsController < ApplicationController
  before_action :authenticate!

  def index
    @tournament = Tournament.new(started_at: Time.zone.now)
  end

  def create
    @tournament = current_user.owned_tournaments.build(tournament_params)
    if @tournament.save
      redirect_to tournaments_path
    else
      flash.now.alert = @tournament.errors.full_messages.to_sentence
      render "index"
    end
  end

  private

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
