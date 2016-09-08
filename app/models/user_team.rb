# Join table between users and teams.
#
class UserTeam < ApplicationRecord
  belongs_to :user
  belongs_to :team

  validates :user_id, uniqueness: { scope: :team_id }
  # No more validations on this join table
end
