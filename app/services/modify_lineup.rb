class ModifyLineup
  attr_reader :current_team

  def initialize(current_team)
    @current_team = current_team
  end

  protected

  def replace_team_in_tournament_with(team)
    team.team_tournaments.build(tournament: tournament)
    # for validation, not for saving.
    tournament.team_tournaments.build(team: team)
    tournament.validate!
    team.save!
    @team_tournament.destroy!
  end

  def replace_team_in_matches_with(team)
    @matches.each do |match|
      case current_team.id
      when match.team_one_id then match.update!(team_one: team)
      when match.team_two_id then match.update!(team_two: team)
      end
    end
  end

  def matches_in_tournament_played_by(team)
    tournament_matches = Match.where(round_id: tournament.round_ids)
    matches = tournament_matches.where(
      team_one_score: nil, team_two_score: nil, team_one_id: team.id
    ).or(
      tournament_matches.where(
        team_one_score: nil, team_two_score: nil, team_two_id: team.id
      )
    )
  end
end
