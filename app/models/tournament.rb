# The implemented tournament type is deathmatch.
#
class Tournament < ApplicationRecord
  belongs_to :game
  belongs_to :owner, class_name: User, inverse_of: :owned_tournaments
  has_many :team_tournaments, dependent: :destroy
  has_many :teams, through: :team_tournaments
  has_many :members, through: :teams, class_name: User
  has_many :related_teams, through: :members, source: :teams, class_name: Team
  has_many :rounds
  has_many :matches, through: :rounds

  after_commit on: [:create, :update] do
    p "perform at #{started_at} id=#{id}"
    p open?
    TournamentStartWorker.perform_at(started_at, id, started_at) if open?
  end

  enum status: {
    open: 0,
    started: 1,
    ended: 2,
  }

  mount_uploader :image, ImageUploader

  validates :game, :owner, :status, presence: true
  validates :title, presence: true, uniqueness: true
  validates :number_of_teams, presence: true, numericality: { greater_than_or_equal_to: 2 }

  validate :no_repeated_members_across_teams,
           :team_sizes_within_limit,
           :number_of_teams_within_limit

  def can_be_started?
    full? && team_tournaments.all?(&:full?)
  end

  def full?
    teams.length == number_of_teams
  end

  def potential_members
    User.where.not(id: members.pluck(:id))
  end

  def potential_teams
    Team.where.not(id: related_teams.pluck(:id))
  end

  private

  def no_repeated_members_across_teams
    errors.add(:teams, "can't have members in common") unless all_members_unique?
  end

  def all_members_unique?
    ids = teams.map(&:id)
    Team.where(id: ids).joins(:members).group(:user_id).count.values.all? { |num| num == 1 }
  end

  def team_sizes_within_limit
    if team_tournaments.any?(&:overfull?)
      # perhaps the error should point to TeamTournament#team_size_limit if that is the cause
      errors.add(:number_of_members_per_team, "is too low")
    end
  end

  def number_of_teams_within_limit
    if teams.length > number_of_teams
      errors.add(:number_of_teams, "Can't be lower than the current number of teams")
    end
  end
end
