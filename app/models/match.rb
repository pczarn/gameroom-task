class Match < ApplicationRecord
  belongs_to :game
  belongs_to :team_one, class_name: Team
  belongs_to :team_two, class_name: Team
  belongs_to :round
  belongs_to :owner, class_name: User, inverse_of: :owned_matches

  scope :friendly, -> { where(round: nil) }

  scope :involving, -> (user_id) do
    joins(team_one: :user_teams, team_two: :user_teams)
      .where(user_teams: { user_id: user_id })
      .distinct
  end

  validates :team_one, :team_two, presence: true
  validates :team_one_score, :team_two_score, numericality: { greater_than_or_equal_to: 0 },
                                              allow_nil: true

  validate :no_repeated_members_across_teams, :played_after_tournament_start

  def winning_team
    @winning_team ||= teams_in_order[0]
  end

  def defeated_team
    @defeated_team ||= teams_in_order[1]
  end

  def teams_in_order
    @teams_in_order ||= begin
      return teams unless team_one_score && team_two_score
      team_one_score < team_two_score ? teams.reverse : teams
    end
  end

  def teams
    @teams ||= [
      TeamInMatch.new(team_one.id, team_one.name, team_one_score),
      TeamInMatch.new(team_two.id, team_two.name, team_two_score),
    ]
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

  def played_after_tournament_start
    if played_at && round && played_at < round.tournament.started_at
      errors.add(:played_at, "Can't be played before the tournament starts")
    end
  end
end

TeamInMatch = Struct.new(:id, :name, :score)
