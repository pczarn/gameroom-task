class TeamTournamentRepresenter < BaseRepresenter
  attr_reader :team_tournament

  def initialize(team_tournament)
    @team_tournament = team_tournament
  end

  def basic
    {
      id: team_tournament.id,
      team_id: team_tournament.team_id,
      number_of_slots: team_tournament.number_of_slots,
      number_of_members: team_tournament.team.members.count,
    }
  end

  def with_team
    basic.merge(
      team: TeamRepresenter.new(team_tournament.team).basic,
    )
  end
end
