class User < ApplicationRecord
  attr_accessor :password

  enum role: {
    user: 0,
    admin: 1,
  }

  has_many :user_teams
  has_many :teams, through: :user_teams

  before_save :encrypt_password

  validates :name, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true
  validates :password, presence: true, confirmation: true, length: { in: 7..100 }, on: :create

  def self.authenticate(email, password)
    return unless user = User.find_by(email: email)
    Argon2::Password.verify_password(password, user.password_hashed) && user
  end

  def encrypt_password
    unless Rails.env.test?
      hasher = Argon2::Password.new(t_cost: cost)
      self.password_hashed = hasher.create(password) if password.present?
    end
  end
end
