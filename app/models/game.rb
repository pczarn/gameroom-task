# Games are video games, foosball, beer pong etc.
#
class Game < ApplicationRecord
  has_many :matches
  has_many :tournaments
  has_many :game_users

  enum state_archivized: {
    archivized: true,
    active: false,
  }

  validates :name, presence: true, uniqueness: true

  mount_uploader :image, ImageUploader
end
