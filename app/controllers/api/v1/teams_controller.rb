module Api
  module V1
    class TeamsController < BaseController
      before_action :authenticate
      before_action :load_team, only: [:show, :update]

      def create
        team = Team.create(team_params)
        render json: TeamRepresenter.new(team)
      end

      def index
        teams = Team.page(params[:page])
        render json: TeamsRepresenter.new(teams)
      end

      def show
        render json: TeamRepresenter.new(@team)
      end

      def update
        @team.update!(team_params)
        render json: TeamRepresenter.new(@team)
      end

      private

      def load_team
        @team = Team.find(params[:id])
      end

      def team_params
        params.require(:team).permit(:name, member_ids: [])
      end
    end
  end
end
