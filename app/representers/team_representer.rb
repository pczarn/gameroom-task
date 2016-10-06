class TeamRepresenter
  attr_reader :team

  def initialize(team)
    @team = team
  end

  def as_json(_ = {})
    {
      id: team.id,
      name: team.name,
      members: UsersRepresenter.new(team.members),
    }
  end
end
