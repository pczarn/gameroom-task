class User < ApplicationRecord
  has_many :user_teams
  has_many :teams, through: :user_teams

  validates_associated :user_teams
end
