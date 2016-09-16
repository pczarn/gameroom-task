class Round < ApplicationRecord
  belongs_to :tournament
  has_many :matches

  validates :number, uniqueness: { scope: :tournament_id }
end
