module Api
  module V1
    class MatchesController < BaseController
      before_action :authenticate
      after_action :verify_authorized
      expose :match, with: :authorize

      def update
        service = FinishMatch.new(match, params: match_params)
        service.perform
        render json: MatchRepresenter.new(match)
      end

      private

      def match_params
        params.require(:match).permit(
          :played_at,
          :team_one_score,
          :team_two_score,
        )
      end
    end
  end
end
