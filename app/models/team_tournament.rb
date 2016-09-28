class TeamTournament < ApplicationRecord
  belongs_to :team
  belongs_to :tournament

  validates :team_id, uniqueness: { scope: :tournament_id }

  def full?
    number_of_slots.nil? || team.members.count == number_of_slots
  end

  def overfull?
    !number_of_slots.nil? && team.members.count > number_of_slots
  end

  private

  def number_of_slots
    [tournament.number_of_members_per_team, team_size_limit].compact.max
  end
end
