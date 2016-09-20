class TournamentStartWorker
  include Sidekiq::Worker

  def perform(tournament_id, performed_at)
    tournament = Tournament.find(tournament_id)
    if tournament.started_at == performed_at
      if tournament.can_be_started?
        start(tournament)
      else
        TournamentStartWorker.perform_in(1.day, tournament_id, performed_at)
      end
    end
  end

  def ready_to_start?(tournament, performed_at)
    tournament.started_at == performed_at && tournament.can_be_started?
  end

  def start(tournament)
    round = tournament.rounds.build(number: 0)
    tournament.teams.each_slice(2) do |team_pair|
      team_one, team_two = *team_pair
      round.matches.build(game: tournament.game, team_one: team_one, team_two: team_two)
    end
    tournament.started!
    tournament.save!
  end
end
