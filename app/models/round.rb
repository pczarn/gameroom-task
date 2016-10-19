class Round < ApplicationRecord
  belongs_to :tournament
  has_many :matches

  validates :number, uniqueness: { scope: :tournament_id }

  def number_of_matches
    tournament.teams.length / 2 / 2**number
  end
end
