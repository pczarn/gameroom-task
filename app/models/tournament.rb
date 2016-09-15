class Tournament < ApplicationRecord
  has_many :team_tournaments
  has_many :teams, through: :team_tournaments

  validates :title, presence: true, uniqueness: true
  validates :number_of_teams, numericality: { greater_than_or_equal_to: 2 }

  validate :number_of_teams_is_power_of_2

  def number_of_teams_is_power_of_2
    errors.add(:number_of_teams, "must be a power of 2") unless power_of_2?(number_of_teams)
  end

  def power_of_2?(number)
    number.nonzero? && (number & (number - 1)).zero?
  end
end
