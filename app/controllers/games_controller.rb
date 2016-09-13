class GamesController < ApplicationController
  def create
    game = Game.create(game_params)
    if game.save
      redirect_to game
    else
      flash[:error] = game.errors.full_messages
      redirect_to action: :index
    end
  end

  def index
    @games = Game.page(params[:page])
    @new_game = Game.new
  end

  def show
    @game = Game.find(params[:id])
  end

  def update
    game = Game.find(params[:id])
    flash[:error] = game.errors.full_messages unless game.update(game_params)
    redirect_to action: :index
  end

  def destroy
    game = Game.find(params[:id])
    game.destroy
    flash[:success] = "Game deleted"
    redirect_to action: :index
  end

  private

  def game_params
    params.require(:game).permit(
      :name,
      image: [],
    )
  end
end
