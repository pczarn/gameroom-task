class UpdateLineup
  attr_reader :current_team, :tournament

  def initialize(team, member_ids:)
    @current_team = team
    @member_ids = member_ids
  end

  def in_match(match)
    @matches = [match]
    @team_tournament = nil
    self
  end

  def in_tournament(tournament)
    @tournament = tournament
    @team_tournament = tournament.team_tournaments.find_by(team: current_team)
    if tournament.started?
      @matches = matches_in_tournament_played_by(current_team)
    else
      @matches = []
    end
    self
  end

  def destroy
    ActiveRecord::Base.transaction do
      destroy_team_in_tournament if tournament
      destroy_team_in_matches
    end
  end

  def replace
    ActiveRecord::Base.transaction do
      team = CreateOrReuseTeam.new(name: current_team.name, member_ids: @member_ids).perform
      replace_team_in_tournament_with(team) if tournament
      replace_team_in_matches_with(team)
    end
  end

  private

  def destroy_team_in_tournament
    @team_tournament.destroy!
  end

  def destroy_team_in_matches
    @matches.each do |match|
      params = scores_for_team_loss(match, current_team)
      service = FinishMatch.new(match, params: params)
      service.perform
    end
  end

  def replace_team_in_tournament_with(team)
    team.team_tournaments.build(tournament: tournament)
    # for validation, not for saving.
    tournament.team_tournaments.build(team: new_team)
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

  def scores_for_team_loss(match, team)
    case team.id
    when match.team_one_id then { team_one_score: 0, team_two_score: 1 }
    when match.team_two_id then { team_one_score: 1, team_two_score: 0 }
    end
  end
end
