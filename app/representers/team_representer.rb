class TeamRepresenter < BaseRepresenter
  attr_reader :team

  def initialize(team)
    @team = team
  end

  def basic
    {
      id: team.id,
      name: team.name,
      member_ids: team.member_ids,
      created_at: team.created_at,
    }
  end

  def with_members
    basic.merge(
      members: UsersRepresenter.new(team.members).basic,
    )
  end
end
