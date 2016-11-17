class TournamentEndWorker
  include Sidekiq::Worker

  def perform(tournament_id, match_id)
    tournament = Tournament.find(tournament_id)
    match = Match.find(match_id)
    broadcast_tournament(tournament)
    notify_about_tournament_end(tournament, match.winning_team)
  end

  private

  def broadcast_tournament(tournament)
    TournamentsChannel.update(tournament)
  end

  def notify_about_tournament_end(tournament, winning_team)
    tournament.teams.includes(:members).each do |team|
      team.member_ids.each do |user_id|
        TournamentStatusMailer.notify_about_end(user_id, tournament.id, winning_team.id).deliver
      end
    end
  end
end
