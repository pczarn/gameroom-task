class ChangeMembershipInTournament
  attr_reader :alert, :notice

  def initialize(team_tournament:, user:)
    @team_tournament = team_tournament
    @user = user
  end

  def join_team
    update(member_ids: current_member_ids + [@user.id])
  end

  def leave_team
    update(member_ids: current_member_ids - [@user.id])
  end

  def tournament
    @team_tournament.tournament
  end

  private

  def update(member_ids:)
    new_team = copy_team(current_team, member_ids: member_ids)
    # for validation, not for saving.
    tournament.team_tournaments.build(team: new_team)

    if member_ids == current_team.member_ids
      @notice = "Your action did not change your team membership."
    elsif !tournament.open?
      @alert = "The tournament has already started."
    elsif tournament.invalid?
      @alert = tournament.errors.full_messages.to_sentence
    elsif !perform_transaction(new_team)
      @alert = new_team.errors.full_messages.to_sentence
    end
  end

  def copy_team(team, member_ids:)
    new_team = add_or_reuse_team(name: current_team.name, member_ids: member_ids)
    new_team.team_tournaments.build(tournament: tournament)
    new_team
  end

  def perform_transaction(new_team)
    TeamTournament.transaction do
      new_team.save && @team_tournament.destroy!
    end
    new_team.persisted?
  end

  def current_team
    @team_tournament.team
  end

  def current_member_ids
    @team_tournament.team.member_ids
  end

  def add_or_reuse_team(params)
    team = Team.new(params)
    member_ids = team.member_ids.sort
    reused = Team.related_to(member_ids).find { |elem| elem.member_ids.sort == member_ids }
    reused || team
  end
end
