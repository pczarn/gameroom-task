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
    if tournament.started?
      team_id = @team_tournament.team_id
      matches = tournament.rounds.joins(:matches)
      matches = matches.where(
        matches: { team_one_score: nil, team_two_score: nil, team_one_id: team_id }
      ).or(
        matches: { team_one_score: nil, team_two_score: nil, team_two_id: team_id }
      )

      if current_team.members.length == 1
        matches.each do |match|
          if match.team_one_id == team_id
            params = { team_one_score: 0, team_two_score: 1 }
          elsif match.team_two_id == team_id
            params = { team_one_score: 1, team_two_score: 0 }
          end
          service = FinishMatch.new(@match, current_user: @user, params: params)
          service.perform
        end
        @team_tournament.destroy!
      else
        team = update(member_ids: current_member_ids - [@user.id])
        matches.each do |match|
          if match.team_one_id == team_id
            match.update!(team_one: team)
          elsif match.team_two_id == team_id
            match.update!(team_two: team)
          end
        end
      end
    elsif current_team.members.length == 1
      @team_tournament.destroy!
    else
      update(member_ids: current_member_ids - [@user.id])
    end
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

    new_team
  end

  def copy_team(team, member_ids:)
    new_team = add_or_reuse_team(name: current_team.name, member_ids: member_ids)
    new_team.team_tournaments.build(tournament: tournament)
    new_team
  end

  def perform_transaction(new_team)
    TeamTournament.transaction do
      begin
        new_team.save!
        @team_tournament.destroy!
      rescue ActiveModel::ValidationError => error
        @alert = error.model.errors.full_messages.to_sentence
        raise ActiveRecord::Rollback
      end
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
