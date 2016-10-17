module Api
  module V1
    class TeamTournamentParticipationsController < BaseController
      before_action :authenticate
      after_action :verify_authorized

      def create
        authorize tournament.team_tournaments.build(team_param)
        tournament.save!
        render json: TournamentRepresenter.new(tournament)
      end

      def destroy
        team_tournament.destroy!
        render json: TournamentRepresenter.new(tournament)
      end

      private

      def tournament
        @tournament ||= Tournament.find(params[:tournament_id])
      end

      def team_tournament
        @team_tournament ||= authorize TeamTournament.find(params[:id])
      end

      def team_id
        params[:team_id]
      end

      def team_param
        if team_id
          { team_id: team_id }
        else
          { team: added_or_reused_team }
        end
      end

      def added_or_reused_team
        @added_or_reused_team ||= add_or_reuse_team
      end

      def add_or_reuse_team
        team = Team.new(add_team_params)
        reused = Team.related_to(team.member_ids).find { |elem| elem.member_ids == team.member_ids }
        reused || team
      end

      def add_team_params
        params.require(:team).permit(:name, member_ids: [])
      end
    end
  end
end
