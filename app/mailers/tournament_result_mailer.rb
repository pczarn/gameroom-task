class TournamentResultMailer < ApplicationMailer
  def result(tournament, winning_team)
    User.each do |user|
      @user = user
      mail(
        to: user.email,
        subject: "The team #{winning_team.name} won the #{tournament.title} tournament",
      )
    end
  end
end
