module Api
  module V1
    class FriendlyMatchesController < BaseController
      before_action :authenticate
      after_action :verify_authorized, only: [:update, :destroy]
      expose :friendly_match, model: Match, scope: -> { Match.friendly }, with: :authorize

      def create
        match = current_user.owned_matches.create!(friendly_match_params)
        render json: MatchRepresenter.new(match).basic
      end

      def index
        matches = FriendlyMatchesRepository.new.fetch
        render json: MatchesRepresenter.new(matches).basic
      end

      def show
        render json: MatchRepresenter.new(friendly_match).basic
      end

      def update
        service = UpdateMatch.new(friendly_match, params: friendly_match_params)
        service.perform
        render json: MatchRepresenter.new(friendly_match).basic
      end

      def destroy
        friendly_match.destroy!
        head :ok
      end

      private

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
