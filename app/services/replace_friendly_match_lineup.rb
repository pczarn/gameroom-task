class ReplaceFriendlyMatchLineup < ModifyLineup
  def initialize(match, team,  member_ids:)
    super(team, member_ids: member_ids)
    @matches = [match]
    @team_tournament = nil
  end

  def perform
    ActiveRecord::Base.transaction do
      team = CreateOrReuseTeam.new(name: current_team.name, member_ids: @member_ids).perform
      replace_team_in_matches_with(team)
      team
    end
  end
end
