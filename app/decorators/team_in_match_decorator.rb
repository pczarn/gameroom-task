class TeamInMatchDecorator < SimpleDelegator
  include Comparable

  attr_reader :score

  def initialize(team, score:)
    @score = score
    super(team)
  end

  def <=>(other)
    (other.score || -1) <=> (@score || -1)
  end
end
