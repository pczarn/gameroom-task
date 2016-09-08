# Teams represent collections of players.
#
class Team < ApplicationRecord
  has_many :user_teams
  has_many :members, through: :user_teams, source: :user, class_name: User

  scope :related_to, -> (user_ids) do
    joins(:user_teams)
      .where(user_teams: { user_id: user_ids })
      .distinct
  end

  validates_associated :user_teams

  validates :name, presence: true, uniqueness: true

  validate :unique_member_collections_for_teams

  # Returns a collection of user ids.
  # Must be public to be used through `map`.
  def member_ids
    members.map(&:id)
  end

  private

  # All teams must be distinct.

  def unique_member_collections_for_teams
    # Check whether any two teams have equal collections of members.
    if contain_duplicates?(this_and_related_teams.map(&:member_ids))
      errors.add(:members, "Teams with these exact members exist")
    end
  end

  # Returns all teams that have members in common with the current team.
  def this_and_related_teams
    # Include the current team, and be careful not to start more validations.
    [self] + Team.related_to(member_ids).includes(:members)
  end
end

private

def contain_duplicates?(ary)
  ary.uniq.length != ary.length
end
