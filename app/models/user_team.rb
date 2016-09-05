class UserTeam < ApplicationRecord
  belongs_to :user
  belongs_to :team

  validates_uniqueness_of :user_id, scope: :team_id
  # No more validations on this join table
end
