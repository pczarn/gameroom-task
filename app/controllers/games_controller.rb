class GamesController < ApplicationController
  before_action :authenticate!
  after_action :verify_authorized, only: [:create, :edit, :update, :destroy]

  def create
    @game = Game.new(game_params)
    authorize @game
    if @game.save
      redirect_to edit_game_path(@game)
    else
      flash.now.alert = @game.errors.full_messages.to_sentence
      render "index"
    end
  end

  def index
    @active_games = Game.active.page(params[:active_games_page])
    @archivized_games = Game.archivized.page(params[:archivized_games_page])
    @game = Game.new
  end

  def edit
    game
  end

  def update
    if game.update(game_params)
      redirect_to edit_game_path(game)
    else
      flash.now.alert = game.errors.full_messages.to_sentence
      render "edit"
    end
  end

  def destroy
    game.destroy
    flash[:success] = "Game deleted"
    redirect_to action: :index
  end

  private

  def game
    @game ||= authorize Game.find(params[:id])
  end

  def game_params
    params.require(:game).permit(
      :name,
      :state_archivized,
      :image,
    )
  end
end
