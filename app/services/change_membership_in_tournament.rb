class ChangeMembershipInTournament
  attr_reader :alert, :notice

  def initialize(team_tournament:, user:)
    @team_tournament = team_tournament
    @user = user
  end

  def join_team
    transaction do
      team = copy_team(current_team, member_ids: current_team.member_ids + [@user.id])
      save_members(team)
    end
  end

  def leave_team
    transaction do
      if current_team.members.length == 1
        destroy_team
      else
        replace_team
      end
    end
  end

  private

  def destroy_team
    if tournament.started?
      matches_in_tournament_played_by(current_team).each do |match|
        params = scores_for_team_loss(match, current_team)
        service = FinishMatch.new(match, current_user: @user, params: params)
        service.perform
      end
    end
    @team_tournament.destroy!
  end

  def replace_team
    team = copy_team(current_team, member_ids: current_team.member_ids - [@user.id])
    save_members(team)
    if tournament.started?
      matches_in_tournament_played_by(current_team).each do |match|
        case current_team.id
        when match.team_one_id then match.update!(team_one: team)
        when match.team_two_id then match.update!(team_two: team)
        end
      end
    end
  end

  def save_members(new_team)
    # for validation, not for saving.
    tournament.team_tournaments.build(team: new_team)

    if new_team.member_ids == current_team.member_ids
      @notice = "Your action did not change your team membership."
    elsif tournament.invalid?
      @alert = tournament.errors.full_messages.to_sentence
    else
      new_team.save!
      @team_tournament.destroy!
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

  def copy_team(team, member_ids:)
    new_team = add_or_reuse_team(name: current_team.name, member_ids: member_ids)
    new_team.team_tournaments.build(tournament: tournament)
    new_team
  end

  def add_or_reuse_team(params)
    team = Team.new(params)
    member_ids = team.member_ids.sort
    reused = Team.related_to(member_ids).find { |elem| elem.member_ids.sort == member_ids }
    reused || team
  end

  def current_team
    @team_tournament.team
  end

  def tournament
    @team_tournament.tournament
  end

  def transaction
    TeamTournament.transaction do
      begin
        yield
      rescue ActiveModel::ValidationError => error
        @alert = error.model.errors.full_messages.to_sentence
        raise ActiveRecord::Rollback
      end
    end
  end
end
