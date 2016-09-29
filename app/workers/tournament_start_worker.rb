class TournamentStartWorker
  include Sidekiq::Worker

  def perform(tournament_id, performed_at)
    tournament = Tournament.find(tournament_id)
    performed_at = performed_at.to_datetime
    try_start(tournament, performed_at) if tournament.started_at == performed_at
  end

  def try_start(tournament, performed_at)
    if tournament.can_be_started?
      start(tournament)
    else
      tournament.update!(started_at: performed_at + 1.day)
    end
  end

  def start(tournament)
    tournament.with_lock do
      return unless tournament.open?
      tournament.build_initial_rounds
      tournament.started!
      tournament.save!
    end
    notify_members_about_start(tournament)
  end

  def notify_members_about_start(tournament)
    tournament.teams.each do |team|
      team.members.each do |member|
        TournamentStatusMailer.notify_about_start(member.id, tournament.id)
      end
    end
  end
end
