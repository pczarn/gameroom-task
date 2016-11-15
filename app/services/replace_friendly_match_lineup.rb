class ReplaceFriendlyMatchLineup < ModifyLineup
  def initialize(match, team,  params:)
    super(team)
    @params = params
    @matches = [match]
    @team_tournament = nil
  end

  def perform
    ActiveRecord::Base.transaction do
      team = CreateOrReuseTeam.new(@params).perform
      team.save!
      replace_team_in_matches_with(team)
      team
    end
  end
end
