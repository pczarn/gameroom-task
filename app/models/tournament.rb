# The implemented tournament type is deathmatch.
#
class Tournament < ApplicationRecord
  belongs_to :game
  belongs_to :owner, class_name: User, inverse_of: :owned_tournaments
  has_many :team_tournaments
  has_many :teams, through: :team_tournaments
  has_many :rounds
  has_many :matches, through: :rounds

  enum status: {
    open: 0,
    started: 1,
    ended: 2,
  }

  mount_uploader :image, ImageUploader

  validates :game, :owner, :status, presence: true
  validates :title, presence: true, uniqueness: true
  validates :number_of_teams, presence: true, numericality: { greater_than_or_equal_to: 2 }

  validate :number_of_teams_is_power_of_2,
           :no_repeated_members_across_teams,
           :team_sizes_within_limit

  def full?
    teams.count >= number_of_teams
  end

  def potential_members
    User.where.not(id: members.pluck(:id))
  end

  def members
    User.joins(:user_teams).where(user_teams: { team_id: teams.pluck(:id) })
  end

  def potential_teams
    Team.where.not(id: related_teams.pluck(:id))
  end

  def related_teams
    Team.related_to(tournament.members.pluck(:id))
  end

  def owned_by?(user)
    owner.id == user.id
  end

  private

  def no_repeated_members_across_teams
    errors.add(:teams, "can't have members in common") unless all_members_unique?
  end

  def all_members_unique?
    ids = teams.map(&:id)
    Team.where(id: ids).joins(:members).group(:user_id).count.values.all? { |num| num == 1 }
  end

  def number_of_teams_is_power_of_2
    errors.add(:number_of_teams, "must be a power of 2") unless power_of_2?(number_of_teams)
  end

  def power_of_2?(number)
    number && number.nonzero? && (number & (number - 1)).zero?
  end

  def team_sizes_within_limit
    if team_tournaments.any?(&:overfull?)
      # perhaps the error should point to TeamTournament#team_size_limit if that is the cause
      errors.add(:number_of_members_per_team, "is too low")
    end
  end
end
