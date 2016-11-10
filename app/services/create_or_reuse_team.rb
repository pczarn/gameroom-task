class CreateOrReuseTeam
  def initialize(params = {})
    @params = params
  end

  def perform
    team = Team.new(@params)
    member_ids = team.member_ids.sort
    reused = Team.joins(:users)
                 .group(:id)
                 .having("array_agg(users.id ORDER BY users.id) = ARRAY[?]", member_ids)[0]
    reused || team
  end
end
