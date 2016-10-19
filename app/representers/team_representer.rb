class TeamRepresenter
  attr_reader :team

  def initialize(team)
    @team = team
  end

  def shallow(_ = {})
    {
      id: team.id,
      name: team.name,
      member_ids: team.member_ids,
    }
  end

  def with_members(_ = {})
    {
      id: team.id,
      name: team.name,
      members: UsersRepresenter.new(team.members),
    }
  end

  def shallow
    as_json
  end

  def with_members
    as_json
  end
end
