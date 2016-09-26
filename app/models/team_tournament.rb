class TeamTournament < ApplicationRecord
  belongs_to :team
  belongs_to :tournament

  validates :team_id, uniqueness: { scope: :tournament_id }

  def full?
    !size_less_than?(tournament.number_of_members_per_team) || !size_less_than?(team_size_limit)
  end

  def overfull?
    !size_within?(tournament.number_of_members_per_team) || !size_within?(team_size_limit)
  end

  private

  def size_less_than?(limit)
    limit.nil? || team.members.count < limit
  end

  def size_within?(limit)
    limit.nil? || team.members.count <= limit
  end
end
