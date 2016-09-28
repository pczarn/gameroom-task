class MatchResultMailer < ApplicationMailer
  def notify_tournament_members(tournament, match)
    tournament.teams.each do |team|
      if team.id == match.winning_team.id
        win(tournament, team, match)
      elsif team.id == match.losing_team.id
        loss(tournament, team, match)
      else
        result(tournament, team, match)
      end
    end
  end

  def win(tournament, team, match)
    team.members.each do |user|
      @user = user
      mail(
        to: user.email,
        subject: "Your team has won a match in the #{tournament.title} tournament",
      )
    end
  end

  def loss(tournament, team, match)
    team.members.each do |user|
      @user = user
      mail(
        to: user.email,
        subject: "Your team has lost a match in the #{tournament.title} tournament",
      )
    end
  end

  def result(tournament, team, match)
    team.members.each do |user|
      @user = user
      mail(
        to: user.email,
        subject: "The team #{team.name} has won a match in the #{tournament.title} tournament",
      )
    end
  end
end
