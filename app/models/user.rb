class User < ApplicationRecord
  attr_accessor :password

  enum role: {
    user: 0,
    admin: 1,
  }

  mount_uploader :image, ImageUploader

  has_many :user_teams
  has_many :teams, through: :user_teams
  has_many :team_tournaments
  has_many :tournaments, through: :team_tournaments

  has_many :owned_matches, class_name: Match,
                           foreign_key: :owner_id,
                           inverse_of: :owner

  has_many :owned_tournaments, source: :tournament,
                               class_name: Tournament,
                               foreign_key: :owner_id,
                               inverse_of: :owner

  before_save :encrypt_password

  validates :name, :email, presence: true, uniqueness: true
  validates :email, format: /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :password, presence: true, length: { in: 7..100 }, on: :create
  validates :password, confirmation: true

  def self.authenticate(email, password)
    return unless user = User.find_by(email: email)
    Argon2::Password.verify_password(password, user.password_hashed) && user
  end

  def encrypt_password
    self.password_hashed = Argon2::Password.create(password) if password.present?
  end
end
