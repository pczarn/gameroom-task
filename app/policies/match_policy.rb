class MatchPolicy < ApplicationPolicy
  attr_reader :match

  def initialize(user, match)
    @user = user
    @match = match
  end

  def update?
    if match.round
      (match.team_one_score.nil? || match.team_two_score.nil?) && (
        match.round.tournament.owner == user ||
        match.team_one.member_ids.include?(user.id) ||
        match.team_two.member_ids.include?(user.id) ||
        user.admin?
      )
    else
      match.owner == user || user.admin?
    end
  end

  def destroy?
    update?
  end
end
