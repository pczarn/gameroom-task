class UserMailer < ApplicationMailer
  def notify_about_tournament_start(member, tournament)
    @user = member
    @tournament = tournament
    mail to: @user.email, subject: "Your tournament has started"
  end
end
