# Games are video games, foosball, beer pong etc.
#
class Game < ApplicationRecord
  has_many :matches, dependent: :destroy
  has_many :tournaments, dependent: :destroy
  has_many :game_users, -> { order(mean: :desc) }, dependent: :destroy

  enum state_archivized: {
    archivized: true,
    active: false,
  }

  validates :name, presence: true, uniqueness: true

  mount_uploader :image, ImageUploader
end
