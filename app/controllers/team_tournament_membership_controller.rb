class TeamTournamentMembershipController < ApplicationController
  include TournamentsHelper

  after_action :verify_authorized

  def create
    authorize tournament, :join?
    service = change_membership_service(current_user)
    service.join_team
    flash.alert = service.alert
    flash.notice = service.notice
    redirect_back fallback_location: edit_tournament_path(tournament)
  end

  def destroy
    if user = params[:user_id] && User.find(params[:user_id])
      authorize team_tournament, :remove_user?
    else
      authorize team_tournament, :leave?
    end
    service = change_membership_service(user || current_user)
    service.leave_team
    flash.alert = service.alert
    flash.notice = service.notice
    redirect_back fallback_location: edit_tournament_path(tournament)
  end

  private

  def change_membership_service(user)
    ChangeMembershipInTournament.new(team_tournament: team_tournament, user: user)
  end

  def team_tournament
    @team_tournament ||= TeamTournament.find(params[:id])
  end

  def tournament
    team_tournament.tournament
  end
end
