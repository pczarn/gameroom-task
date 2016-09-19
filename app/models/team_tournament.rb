class TeamTournament < ApplicationRecord
  belongs_to :team
  belongs_to :tournament

  validates :team_id, uniqueness: :tournament_id
end
