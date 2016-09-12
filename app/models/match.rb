class Match < ApplicationRecord
  belongs_to :game
  belongs_to :team_one, class_name: Team
  belongs_to :team_two, class_name: Team

  validates :played_at, :team_one, :team_two, presence: true
  validates :team_one_score, :team_two_score, numericality: { greater_than_or_equal_to: 0 },
                                              allow_nil: true

  validate :no_repeated_members_across_teams

  def teams_in_order
    teams = [
      TeamInMatch.new(team_one.name, team_one_score || "—"),
      TeamInMatch.new(team_two.name, team_two_score || "—"),
    ]
    if team_one_score && team_two_score
      teams.reverse! if team_one_score < team_two_score
    end
    teams
  end

  private

  def no_repeated_members_across_teams
    common_members = team_one.member_ids & team_two.member_ids
    if common_members.any?
      [:team_one, :team_two].each do |team_sym|
        errors.add(team_sym, "can't have members in common with the other team")
      end
    end
  end
end

TeamInMatch = Struct.new(:name, :score)
