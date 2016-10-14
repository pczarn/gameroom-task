module Api
  module V1
    class GamesController < BaseController
      before_action :authenticate!
      after_action :verify_authorized, only: [:create, :update, :destroy]

      def create
        game = Game.new(game_params)
        authorize game
        game.save!
        render json: GameRepresenter.new(game)
      end

      def index
        render json: GamesRepresenter.new(Game.all)
      end

      def show
        render json: GameRepresenter.new(game)
      end

      def update
        game.update!(game_params)
        render json: GameRepresenter.new(game)
      end

      def destroy
        @game.destroy!
        head :ok
      end

      private

      def game
        @game ||= authorize Game.find(params[:id])
      end

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
