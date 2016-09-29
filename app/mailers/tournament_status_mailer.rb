class TournamentStatusMailer < ApplicationMailer
  def notify_about_start(member_id, tournament_id)
    @user = User.find(member_id)
    @tournament = Tournament.find(tournament_id)
    mail(to: @user.email, subject: "Your tournament has started").deliver_now
  end

  def notify_about_end(tournament_id, winning_team_id)
    tournament = Tournament.find(tournament_id)
    winning_team = Team.find(winning_team_id)
    User.each do |user|
      @user = user
      subject = subject_for_tournament_win(tournament, winning_team)
      mail(to: user.email, subject: subject).deliver_now
    end
  end

  def notify_about_match_result(tournament, match)
    tournament.teams.each do |team|
      subject = subject_for_team_result_in_match(tournament, match, team)
      team.members.each do |user|
        @user = user
        mail(to: user.email, subject: subject).deliver_now
      end
    end
  end

  private

  def subject_for_tournament_win(tournament, team)
    "The team #{team.name} won the #{tournament.title} tournament"
  end

  def subject_for_team_result_in_match(tournament, match, team)
    if team.id == match.winning_team.id
      subject_for_match_win(tournament)
    elsif team.id == match.losing_team.id
      subject_for_match_loss(tournament)
    else
      subject_for_match_result(tournament, team)
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
