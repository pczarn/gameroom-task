module Api
  module V1
    class GamesController < BaseController
      before_action :authenticate
      after_action :verify_authorized, only: [:create, :update, :destroy]
      expose :game, with: :authorize

      def create
        game.save!
        render json: GameRepresenter.new(game).with_stats
      end

      def index
        games = GamesRepository.new.fetch
        render json: GamesRepresenter.new(games).with_stats
      end

      def show
        render json: GameRepresenter.new(game).with_stats
      end

      def update
        game.update!(game_params)
        render json: GameRepresenter.new(game).with_stats
      end

      def destroy
        game.destroy!
        head :ok
      end

      private

      def game_params
        params.require(:game).permit(
          :name,
          :state_archivized,
          :image,
        )
      end
    end
  end
end
