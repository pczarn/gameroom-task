class TournamentStartWorker
  include Sidekiq::Worker

  def perform(tournament_id, performed_at)
    tournament = Tournament.find(tournament_id)
    try_start(tournament, performed_at) if tournament.started_at == performed_at
  end

  def try_start(tournament, performed_at)
    if tournament.can_be_started?
      start(tournament)
    else
      TournamentStartWorker.perform_in(1.day, tournament.id, performed_at)
    end
  end

  def start(tournament)
    tournament.build_first_round
    tournament.started!
    tournament.save!
    notify_members_about_start(tournament)
  end

  def notify_members_about_start(tournament)
    tournament.teams.each do |team|
      team.members.each do |member|
        UserMailer.notify_about_tournament_start(member, tournament)
      end
    end
  end
end
