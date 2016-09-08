# Games are video games, foosball, beer pong etc.
#
class Game < ApplicationRecord
  has_many :match

  validates :name, presence: true
end
