class Match < ApplicationRecord
  belongs_to :game
  belongs_to :team_one, class_name: Team
  belongs_to :team_two, class_name: Team

  validates :played_at, :team_one, :team_two, presence: true
  validates :team_one_score, :team_two_score, numericality: { greater_than_or_equal_to: 0 },
                                              allow_nil: true

  validate :no_repeated_members_across_teams

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
