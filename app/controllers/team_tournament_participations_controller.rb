class TeamTournamentParticipationsController < ApplicationController
  after_action :verify_authorized

  def create
    if team_params = build_team_params
      authorize tournament.team_tournaments.build(team_params)
      unless tournament.save
        flash.alert = tournament.errors.full_messages.to_sentence
      end
    else
      flash.alert = added_or_reused_team.errors.full_messages.to_sentence
    end
    redirect_back fallback_location: edit_tournament_path(tournament)
  end

  def destroy
    team_tournament.destroy!
    redirect_back fallback_location: edit_tournament_path(team_tournament.tournament)
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

  def build_team_params
    if team_id
      { team_id: team_id }
    elsif added_or_reused_team.valid?
      { team: added_or_reused_team }
    end
  end

  def added_or_reused_team
    @added_or_reused_team ||= add_or_reuse_team
  end

  def add_or_reuse_team
    team = Team.new(team_params)
    member_ids = team.member_ids.sort
    reused = Team.related_to(member_ids).find { |elem| elem.member_ids.sort == member_ids }
    reused || team
  end

  def team_params
    params.require(:team).permit(:name, member_ids: [])
  end
end
