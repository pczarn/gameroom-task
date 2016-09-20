class User < ApplicationRecord
  attr_accessor :password

  enum role: {
    user: 0,
    admin: 1,
  }

  has_many :user_teams
  has_many :teams, through: :user_teams
  has_many :team_tournaments
  has_many :tournaments, through: :team_tournaments

  has_many :owned_tournaments, source: :tournament,
                               class_name: Tournament,
                               foreign_key: :owner_id,
                               inverse_of: :owner

  before_save :encrypt_password

  validates :name, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true
  validates :password, presence: true, confirmation: true, length: { in: 7..100 }, on: :create

  def self.authenticate(email, password)
    return unless user = User.find_by(email: email)
    Argon2::Password.verify_password(password, user.password_hashed) && user
  end

  def encrypt_password
    if password_hashed.blank? && password.present?
      self.password_hashed = Argon2::Password.create(password)
    end
  end
end
