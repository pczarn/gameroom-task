module Api
  module V1
    class TeamLineupMembersController < BaseController
      after_action :verify_authorized
      expose :team_tournament
      expose :user
      delegate :tournament, to: :team_tournament

      def create
        authorize tournament, :join?
        service = change_membership_service(current_user)
        service.join_team
        head :ok
      end

      def destroy
        if user
          authorize team_tournament, :remove_user?
        else
          authorize team_tournament, :leave?
        end
        service = change_membership_service(user || current_user)
        service.leave_team
        head :ok
      end

      private

      def change_membership_service(user)
        ChangeMembershipInTournament.new(team_tournament: team_tournament, user: user)
      end
    end
  end
end
