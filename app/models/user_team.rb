class UserTeam < ApplicationRecord
  belongs_to :user
  belongs_to :team

  enum role: {
    regular: 0,
    owner: 1,
  }

  validates :user_id, uniqueness: { scope: :team_id }
end
