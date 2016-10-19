class TournamentStatusMailer < ApplicationMailer
  def notify_about_start(member_id, tournament_id)
    @user = User.find(member_id)
    @tournament = Tournament.find(tournament_id)
    mail(to: @user.email, subject: "Your tournament has started")
  end

  def notify_about_end(user_id, tournament_id, winning_team_id)
    @user = User.find(user_id)
    @tournament = Tournament.find(tournament_id)
    winning_team = Team.find(winning_team_id)
    subject = subject_for_tournament_win(@tournament, winning_team)
    mail(to: @user.email, subject: subject)
  end

  def notify_about_match_result(member_id, match_id)
    @user = User.find(member_id)
    match = Match.find(match_id)
    tournament = match.round.tournament
    subject = subject_for_team_result_in_match(tournament, match, @user)
    @result = player_result_in_match(match, @user)
    @winning_team = match.winning_team
    @defeated_team = match.defeated_team
    mail(to: @user.email, subject: subject)
  end

  private

  def player_result_in_match(match, user)
    if UserTeam.exists?(user: user, team_id: match.winning_team.id)
      :win
    elsif UserTeam.exists?(user: user, team_id: match.defeated_team.id)
      :loss
    end
  end

  def subject_for_tournament_win(tournament, team)
    "The team #{team.name} won the #{tournament.title} tournament"
  end

  def subject_for_team_result_in_match(tournament, match, user)
    case player_result_in_match(match, user)
    when :win then subject_for_match_win(tournament)
    when :loss then subject_for_match_loss(tournament)
    else
      subject_for_match_result(tournament, Team.find(match.winning_team.id))
    end
  end

  def subject_for_match_win(tournament)
    "Your team won a match in the #{tournament.title} tournament"
  end

  def subject_for_match_loss(tournament)
    "Your team lost a match in the #{tournament.title} tournament"
  end

  def subject_for_match_result(tournament, team)
    "The team #{team.name} won a match in the #{tournament.title} tournament"
  end
end
