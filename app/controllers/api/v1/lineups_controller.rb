module Api
  module V1
    class LineupsController < BaseController
      before_action :authenticate
      after_action :verify_authorized
      expose :team
      expose :friendly_match, model: Match
      expose :tournament

      def create
        authorize tournament.team_tournaments.build(team: create_team)
        tournament.save!
        render json: TournamentRepresenter.new(tournament)
      end

      def update
        if params[:friendly_match_id]
          authorize_update friendly_match
          team = update_lineup_service.in_friendly_match(friendly_match).replace
        elsif params[:tournament_id]
          authorize_update team_tournament
          team = update_lineup_service.in_tournament(tournament).replace
        end
        render json: TeamRepresenter.new(team).shallow
      end

      def destroy
        authorize team_tournament
        update_lineup_service.in_tournament(tournament).destroy
        head :ok
      end

      private

      def authorize_update(model)
        if leaving?
          authorize model, :leave?
        else
          authorize model, :update?
        end
      end

      def update_lineup_service
        UpdateLineup.new(team, member_ids: params[:team] && team_params[:member_ids])
      end

      def create_team
        params[:id] ? team : CreateOrReuseTeam.new(add_team_params).perform
      end

      def leaving?
        team.members.size == team_params[:member_ids].size + 1 &&
          team.members.include?(current_user) &&
          team_params[:member_ids].include?(current_user.id)
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
