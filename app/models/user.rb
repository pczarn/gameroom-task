class User < ApplicationRecord
  attr_reader :password

  enum role: {
    user: 0,
    admin: 1,
  }

  mount_uploader :image, ImageUploader

  has_many :user_teams
  has_many :teams, through: :user_teams
  has_many :team_tournaments
  has_many :tournaments, through: :team_tournaments
  has_many :game_users

  has_many :owned_matches, class_name: Match,
                           foreign_key: :owner_id,
                           inverse_of: :owner

  has_many :owned_tournaments, source: :tournament,
                               class_name: Tournament,
                               foreign_key: :owner_id,
                               inverse_of: :owner

  validates :name, :email, presence: true, uniqueness: true
  validates :email, format: /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :password, presence: true, length: { in: 7..100 }, on: :create
  validates :password, confirmation: true

  def authenticate(password)
    Argon2::Password.verify_password(password, password_hashed) && self
  end

  def password=(pass)
    if pass.nil?
      @password = nil
      self.password_hashed = nil
    elsif !pass.empty?
      @password = pass
      self.password_hashed = Argon2::Password.create(pass)
    end
  end
end
