class Team < ApplicationRecord
  has_many :user_teams
  has_many :members, through: :user_teams, source: :user, class_name: User

  scope :related_to, -> (user_ids) do
    joins(:user_teams)
      .where(user_teams: { user_id: user_ids })
      .distinct
  end

  validates :name, presence: true, uniqueness: true

  validate :unique_member_collections_for_teams

  private

  def unique_member_collections_for_teams
    if contains_duplicates?(this_and_related_team_member_ids)
      errors.add(:members, "Teams with these exact members exist")
    end
  end

  def contains_duplicates?(ary)
    ary.uniq.length != ary.length
  end

  def this_and_related_team_member_ids
    this_and_related_teams.map { |team| team.members.map(&:id) }
  end

  def this_and_related_teams
    [self] + Team.related_to(members.map(&:id)).includes(:members)
  end
end
