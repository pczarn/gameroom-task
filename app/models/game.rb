# Games are video games, foosball, beer pong etc.
#
class Game < ApplicationRecord
  has_many :matches

  validates :name, presence: true, uniqueness: true

  mount_uploader :image, ImageUploader
end
