class Match < ApplicationRecord
  belongs_to :game
  belongs_to :team_one, class_name: Team
  belongs_to :team_two, class_name: Team
  belongs_to :round
  belongs_to :owner, class_name: User, inverse_of: :owned_matches

  delegate :tournament, to: :round

  scope :friendly, -> { where(round: nil) }

  scope :involving, ->(user_id) do
    joins(team_one: :user_teams, team_two: :user_teams)
      .where(user_teams: { user_id: user_id })
      .distinct
  end

  validates :game, :team_one, :team_two, presence: true
  validates :team_one_score, :team_two_score, numericality: { greater_than_or_equal_to: 0 },
                                              allow_nil: true

  validate :no_repeated_members_across_teams, :played_after_tournament_start

  def winning_team
    teams_ordered_by_score[0]
  end

  def defeated_team
    teams_ordered_by_score[1]
  end

  def teams_ordered_by_score
    @teams_ordered_by_score ||= teams.sort
  end

  def scores
    [team_one_score, team_two_score]
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
    if played_at && round && played_at < tournament.started_at
      errors.add(:played_at, "Can't be played before the tournament starts")
    end
  end

  def teams
    @teams ||= [
      TeamInMatchDecorator.new(team_one, score: team_one_score),
      TeamInMatchDecorator.new(team_two, score: team_two_score),
    ]
  end
end
