# Matches are played between teams.
# Add friendly and unfriendly matches later.
#
class Match < ApplicationRecord
  belongs_to :game
  belongs_to :team_one, class_name: Team
  belongs_to :team_two, class_name: Team

  validates :played_at, presence: true
  validate :teams_not_empty, :no_repeated_player_in_different_teams

  private

  # Teams not empty

  def teams_not_empty
    team_not_empty(:team_one)
    team_not_empty(:team_two)
  end

  def team_not_empty(team_field)
    team = send(team_field)
    errors.add(team_field, "Can't be empty") if UserTeam.where(team: team).empty?
  end

  # No repeated players

  def no_repeated_player_in_different_teams
    # self-join?! no. pluck user ids for intersection.
    # There are two approaches. This one goes through UserTeam.
    users_in_team_one = UserTeam.where(team: team_one).pluck(:user_id)
    users_in_team_two = UserTeam.where(team: team_two).pluck(:user_id)
    common_players = users_in_team_one & users_in_team_two
    if not common_players.empty?
      [:team_one, :team_two].each do |team_sym|
        errors.add(team_sym, "Can't have players in both teams")
      end
    end
  end
end
