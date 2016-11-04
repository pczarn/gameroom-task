class TeamsRepresenter < BaseRepresenter
  attr_reader :teams

  def initialize(teams)
    @teams = teams
  end

  def basic
    teams.map { |team| TeamRepresenter.new(team).basic }
  end

  def with_members
    teams.map { |team| TeamRepresenter.new(team).with_members }
  end
end
