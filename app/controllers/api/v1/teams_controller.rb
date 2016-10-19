module Api
  module V1
    class TeamsController < BaseController
      before_action :authenticate
      after_action :verify_authorized, only: :update

      def create
        team = Team.create!(team_params)
        render json: TeamRepresenter.new(team)
      end

      def index
        teams = TeamsRepository.new.teams
        render json: TeamsRepresenter.new(teams)
      end

      def show
        render json: TeamRepresenter.new(team)
      end

      def update
        team.update!(team_params)
        render json: TeamRepresenter.new(team)
      end

      private

      def team
        @team ||= authorize Team.find(params[:id])
      end

      def team_params
        params.require(:team).permit(:name, member_ids: [])
      end
    end
  end
end
