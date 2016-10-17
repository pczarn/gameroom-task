class TeamsRepresenter
  attr_reader :teams

  def initialize(teams)
    @teams = teams
  end

  def shallow(_ = {})
    teams.map { |team| TeamRepresenter.new(team).shallow }
  end

  def with_members(_ = {})
    teams.map { |team| TeamRepresenter.new(team).with_members }
  end

  def as_json(_ = {})
    shallow
  end
end
