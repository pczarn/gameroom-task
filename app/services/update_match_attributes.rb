class UpdateMatchAttributes
  def initialize(match:, params:)
    @match = match
    @params = params
  end

  def perform
    @match.update!(@params)
  end
end
