class EndTournament
  def initialize(tournament:, match:)
    @tournament = tournament
    @match = match
  end

  def perform
    @tournament.update!(status: :ended)
    EndTournament.delay.notify_about_tournament_end(@tournament.id, @match.winning_team.id)
    broadcast_tournament
  end

  def broadcast_tournament
    ActionCable.server.broadcast "tournaments",
                                 TournamentRepresenter.new(@tournament).with_teams_and_rounds
  end

  def self.notify_about_tournament_end(tournament_id, winning_team_id)
    tournament = Tournament.find(tournament_id)
    tournament.teams.includes(:members).each do |team|
      team.member_ids.each do |user_id|
        TournamentStatusMailer.notify_about_end(user_id, tournament_id, winning_team_id).deliver
      end
    end
  end
end
