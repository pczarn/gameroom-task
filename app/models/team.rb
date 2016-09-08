# Teams represent collections of players.
#
class Team < ApplicationRecord
  has_many :user_teams
  has_many :users, through: :user_teams

  scope :related_to, -> (user_ids) do
    joins(:user_teams)
      .where(user_teams: { user_id: user_ids })
      .distinct
  end

  validates_associated :user_teams

  validates :name, presence: true

  validate :unique_user_collections_for_teams

  # Returns a collection of user ids.
  # Must be public to be used through `map`.
  def user_ids
    users.map(&:id)
  end

  private

  # All teams must be distinct.

  def unique_user_collections_for_teams
    # Check whether any two teams have equal collections of users.
    if contain_duplicates?(this_and_related_teams.map(&:user_ids))
      errors.add(:users, "Teams with these exact users exist")
    end
  end

  # Returns all teams that have users in common with the current team.
  def this_and_related_teams
    # Include the current team, and be careful not to start more validations.
    [self] + Team.related_to(user_ids).includes(:users)
  end
end

private

def contain_duplicates?(ary)
  ary.uniq.length != ary.length
end
