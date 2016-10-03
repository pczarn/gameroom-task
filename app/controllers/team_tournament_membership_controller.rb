class TeamTournamentMembershipController < ApplicationController
  def create
    service = change_membership_service
    service.join_team
    flash.alert = service.alert
    flash.notice = service.notice
    redirect_back fallback_location: edit_tournament_path(service.tournament)
  end

  def destroy
    service = change_membership_service
    service.leave_team
    flash.alert = service.alert
    flash.notice = service.notice
    redirect_back fallback_location: edit_tournament_path(service.tournament)
  end

  private

  def change_membership_service
    team_tournament = TeamTournament.find(params[:id])
    ChangeMembershipInTournament.new(team_tournament: team_tournament, user: current_user)
  end
end
