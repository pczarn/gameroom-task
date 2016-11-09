class ReplaceTournamentLineup < ModifyLineup
  attr_reader :tournament

  def initialize(tournament, team, member_ids:)
    super(team, member_ids: member_ids)
    @tournament = tournament
    @team_tournament = tournament.team_tournaments.find_by(team: current_team)
    if tournament.started?
      @matches = matches_in_tournament_played_by(current_team)
    else
      @matches = []
    end
  end

  def perform
    ActiveRecord::Base.transaction do
      team = CreateOrReuseTeam.new(name: current_team.name, member_ids: @member_ids).perform
      replace_team_in_tournament_with(team)
      replace_team_in_matches_with(team)
      team
    end
  end
end
