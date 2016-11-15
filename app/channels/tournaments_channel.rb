class TournamentsChannel < ApplicationCable::Channel
  def subscribed
    stream_from "tournaments"
  end

  def self.update
    ActionCable.server.broadcast "tournaments",
                                 TournamentRepresenter.new(tournament).with_teams_and_rounds
  end
end
