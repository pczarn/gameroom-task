class TeamTournament < ApplicationRecord
  belongs_to :team
  belongs_to :tournament

  validates :team_id, uniqueness: { scope: :tournament_id }

  def full?
    size_limit.nil? || team.members.count >= size_limit
  end

  def overfull?
    !size_limit.nil? && team.members.count > size_limit
  end

  private

  def size_limit
    [tournament.number_of_members_per_team, team_size_limit].compact.max
  end
end
