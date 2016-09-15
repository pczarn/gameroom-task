class MatchTournament < ApplicationRecord
  belongs_to :match
  belongs_to :tournament

  validates :match_id, uniqueness: { scope: :tournament_id }
end
