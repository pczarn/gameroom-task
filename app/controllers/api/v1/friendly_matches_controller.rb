module Api
  module V1
    class FriendlyMatchesController < BaseController
      before_action :authenticate
      after_action :verify_authorized, only: [:update, :destroy]

      def create
        match = current_user.owned_matches.create!(friendly_match_params)
        render json: MatchRepresenter.new(match)
      end

      def index
        recent = Match.friendly.order(played_at: :desc)
        recent = recent.involving(params[:involving_user]) if params[:involving_user]
        recent = recent.page(params[:page])
        render json: MatchesRepresenter.new(recent)
      end

      def show
        render json: MatchRepresenter.new(friendly_match)
      end

      def update
        service = FinishMatch.new(friendly_match, params: friendly_match_params)
        service.perform
        render json: MatchRepresenter.new(friendly_match)
      end

      def destroy
        friendly_match.destroy!
        head :ok
      end

      private

      def friendly_match
        @match ||= authorize Match.friendly.find(params[:id])
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
    end
  end
end
