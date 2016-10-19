module Api
  module V1
    class TournamentsController < BaseController
      before_action :authenticate
      after_action :verify_authorized, only: [:update, :destroy]
      expose :tournament, with: :authorize

      def index
        tournaments = TournamentsRepository.new.tournaments
        render json: TournamentsRepresenter.new(tournaments).with_teams_and_rounds
      end

      def create
        tournament = current_user.owned_tournaments.build(tournament_params)
        tournament.save!
        render json: TournamentRepresenter.new(tournament).with_teams_and_rounds
      end

      def show
        render json: TournamentRepresenter.new(tournament).with_teams_and_rounds
      end

      def update
        tournament.update!(tournament_params)
        render json: TournamentRepresenter.new(tournament).with_teams_and_rounds
      end

      def destroy
        tournament.destroy!
        head :ok
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
  end
end
