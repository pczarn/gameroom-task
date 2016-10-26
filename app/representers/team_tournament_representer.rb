class TeamTournamentRepresenter < BaseRepresenter
  attr_reader :team_tournament

  def initialize(team_tournament)
    @team_tournament = team_tournament
  end

  def basic
    {
      id: team_tournament.id,
      number_of_slots: team_tournament.number_of_slots,
      number_of_members: team_tournament.team.members.count,
    }
  end

  def shallow(_ = {})
    basic.merge(
      team_id: team_tournament.team_id,
    )
  end

  def with_team(_ = {})
    basic.merge(
      team: TeamRepresenter.new(team_tournament.team).shallow,
    )
  end
end
