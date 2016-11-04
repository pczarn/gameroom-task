module Api
  module V1
    class MatchesController < BaseController
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
        match_params = match.round.present? ? match_in_tournament_params : friendly_match_params
        service = FinishMatch.new(match, params: match_params)
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

      def match
        @match ||= authorize Match.find(params[:id])
      end

      def match_in_tournament_params
        params.require(:match).permit(
          :played_at,
          :team_one_score,
          :team_two_score,
        )
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
