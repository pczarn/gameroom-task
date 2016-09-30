class TeamTournamentMembershipController < ApplicationController
  def update
    team_tournament = TeamTournament.find(params[:id])
    tournament = team_tournament.tournament
    current_team = team_tournament.team
    member_ids = current_team.member_ids

    if params[:join]
      member_ids += [current_user.id]
    elsif params[:leave]
      member_ids -= [current_user.id]
    end

    new_team = add_or_reuse_team(name: current_team.name, member_ids: member_ids)
    new_team.team_tournaments.build(tournament: tournament)
    # for validation, not saving.
    tournament.team_tournaments.build(team: new_team)

    if member_ids == current_team.member_ids
      flash.notice = "Your action did not change your team membership."
    elsif !tournament.open?
      flash.alert = "The tournament has already started."
    elsif tournament.valid?
      TeamTournament.transaction do
        if new_team.save
          team_tournament.destroy!
        end
      end

      unless new_team.persisted?
        flash.alert = new_team.errors.full_messages.to_sentence
      end
    else
      flash.alert = tournament.errors.full_messages.to_sentence
    end

    redirect_back fallback_location: edit_tournament_path(tournament)
  end

  private

  def add_or_reuse_team(params)
    team = Team.new(params)
    member_ids = team.member_ids.sort
    if reused = Team.related_to(member_ids).find { |elem| elem.member_ids.sort == member_ids }
      reused
    else
      team
    end
  end
end
