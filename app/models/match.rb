class Match < ApplicationRecord
  belongs_to :game
  belongs_to :team_one, class_name: Team
  belongs_to :team_two, class_name: Team

  validates :played_at, presence: true
  validates :team_one_score, :team_two_score, numericality: { greater_than_or_equal_to: 0 },
                                              allow_nil: true

  validate :teams_not_empty, :no_repeated_members_across_teams

  private

  def teams_not_empty
    team_not_empty(:team_one)
    team_not_empty(:team_two)
  end

  def team_not_empty(team_field)
    team = send(team_field)
    errors.add(team_field, "Can't be empty") if UserTeam.where(team: team).empty?
  end

  def no_repeated_members_across_teams
    users_in_team_one = UserTeam.where(team: team_one).pluck(:user_id)
    users_in_team_two = UserTeam.where(team: team_two).pluck(:user_id)
    common_members = users_in_team_one & users_in_team_two
    unless common_members.empty?
      [:team_one, :team_two].each do |team_sym|
        errors.add(team_sym, "Can't have common members in both teams")
      end
    end
  end
end
