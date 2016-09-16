class Tournament < ApplicationRecord
  belongs_to :game
  has_many :team_tournaments
  has_many :teams, through: :team_tournaments

  validates :title, presence: true, uniqueness: true
  validates :number_of_teams, numericality: { greater_than_or_equal_to: 2 }

  validate :number_of_teams_is_power_of_2, :no_repeated_members_across_teams

  private

  def no_repeated_members_across_teams
    errors.add(:teams, "can't have members in common") unless all_members_unique?
  end

  def all_members_unique?
    teams.joins(:members).group(:user_id).count.values.all? { |num| num == 1 }
  end

  def number_of_teams_is_power_of_2
    errors.add(:number_of_teams, "must be a power of 2") unless power_of_2?(number_of_teams)
  end

  def power_of_2?(number)
    number.nonzero? && (number & (number - 1)).zero?
  end
end
