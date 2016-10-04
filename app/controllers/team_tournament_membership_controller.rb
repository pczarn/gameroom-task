class TeamTournamentMembershipController < ApplicationController
  include TournamentsHelper

  def create
    if can_join?(user, team_tournament.tournament)
      service = change_membership_service
      service.join_team
      flash.alert = service.alert
      flash.notice = service.notice
    else
      flash.alert = "You can't join the tournament."
    end
    redirect_back fallback_location: edit_tournament_path(tournament)
  end

  def destroy
    if can_leave?(user, team_tournament)
      service = change_membership_service
      service.leave_team
      flash.alert = service.alert
      flash.notice = service.notice
    else
      flash.alert = "You can't leave the tournament."
    end
    redirect_back fallback_location: edit_tournament_path(tournament)
  end

  private

  def change_membership_service
    ChangeMembershipInTournament.new(team_tournament: team_tournament, user: user)
  end

  def team_tournament
    @team_tournament ||= TeamTournament.find(params[:id])
  end

  def tournament
    team_tournament.tournament
  end

  def user
    @user ||= params[:user_id] ? User.find(params[:user_id]) : current_user
  end
end
