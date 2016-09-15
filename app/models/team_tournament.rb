class TeamTournament < ApplicationRecord
  belongs_to :team
  belongs_to :tournament

  validates :team_id, uniqueness: { scope: :tournament_id }
end
