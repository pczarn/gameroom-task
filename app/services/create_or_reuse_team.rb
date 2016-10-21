class CreateOrReuseTeam
  def initialize(params = {})
    @params = params
  end

  def perform
    team = Team.new(@params)
    member_ids = team.member_ids.sort
    reused = Team.related_to(member_ids).find { |elem| elem.member_ids.sort == member_ids }
    reused || team
  end
end
