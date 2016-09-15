class Tournament < ApplicationRecord
  has_many :match_tournaments
  has_many :matches, through: :match_tournaments
end
