class Game < ApplicationRecord
  has_many :match

  validates_presence_of :name
end
