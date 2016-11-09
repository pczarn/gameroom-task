class DestroyTournamentLineup < ModifyLineup
  attr_reader :tournament

  def initialize(tournament, current_team, member_ids:)
    super(current_team, member_ids: member_ids)
    @tournament = tournament
    @team_tournament = tournament.team_tournaments.find_by(team: current_team)
    if tournament.started?
      @matches = matches_in_tournament_played_by(current_team)
    else
      @matches = []
    end
  end

  def perform
    ActiveRecord::Base.transaction do
      destroy_team_in_tournament
      destroy_team_in_matches
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

  def scores_for_team_loss(match, team)
    case team.id
    when match.team_one_id then { team_one_score: 0, team_two_score: 1 }
    when match.team_two_id then { team_one_score: 1, team_two_score: 0 }
    end
  end
end
