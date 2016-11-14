class GameUserRepresenter < BaseRepresenter
  attr_reader :game_user

  def initialize(game_user)
    @game_user = game_user
  end

  def basic
    {
      user_id: game_user.user_id,
      mean: game_user.mean,
    }
  end
end
