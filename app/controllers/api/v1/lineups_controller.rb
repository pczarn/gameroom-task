module Api
  module V1
    class LineupsController < BaseController
      before_action :authenticate
      after_action :verify_authorized
      expose :team
      expose :friendly_match, model: Match
      expose :tournament

      def create
        if params[:id]
          service = CreateTournamentLineup.new(tournament, team: team)
        else
          service = CreateTournamentLineup.new(tournament, params: add_team_params)
        end
        authorize service.team_tournament
        service.perform
        render json: TournamentRepresenter.new(tournament)
      end

      def update
        if params[:friendly_match_id]
          authorize_update friendly_match
          service = ReplaceFriendlyMatchLineup.new(
            friendly_match,
            team,
            member_ids: member_ids_param,
          )
        elsif params[:tournament_id]
          authorize_update team_tournament
          service = ReplaceTournamentLineup.new(
            tournament,
            team,
            member_ids: member_ids_param,
          )
        end
        updated_team = service.perform
        render json: TeamRepresenter.new(updated_team).basic
      end

      def destroy
        authorize team_tournament
        DestroyTournamentLineup.new(tournament, team, member_ids: member_ids_param).perform
        head :ok
      end

      private

      def authorize_update(model)
        if leaving?
          authorize model, :leave?
        elsif joining?
          authorize model, :join?
        else
          authorize model, :update?
        end
      end

      def leaving?
        team.members.size == team_params[:member_ids].size + 1 &&
          team.members.include?(current_user) &&
          !team_params[:member_ids].map(&:to_i).include?(current_user.id)
      end

      def joining?
        team.members.size == team_params[:member_ids].size - 1 &&
          !team.members.include?(current_user) &&
          team_params[:member_ids].map(&:to_i).include?(current_user.id)
      end

      def member_ids_param
        params[:team] && team_params[:member_ids]
      end

      def add_team_params
        params.require(:team).permit(:name, member_ids: [])
      end

      def team_params
        params.require(:team).permit(member_ids: [])
      end

      def team_tournament
        @team_tournament ||= tournament.team_tournaments.find_by(team: team)
      end
    end
  end
end
