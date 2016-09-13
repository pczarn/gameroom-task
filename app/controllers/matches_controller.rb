class MatchesController < ApplicationController
  before_filter :load_match, only: [:show, :update, :destroy]

  def create
    @match = Match.create(match_params)
    if @match.save
      redirect_to @match
    else
      flash[:error] = @match.errors.full_messages
      redirect_to action: :index
    end
  end

  def index
    sanitize_param
    @new_match = Match.new
    @recent = Match.order(played_at: :desc)
    @recent = @recent.involving(params[:involving_user]) if params[:involving_user]
    @recent = @recent.page(params[:page])
    @game_ids_names = Game.all.pluck(:id, :name)
    @team_ids_names = Team.all.pluck(:id, :name)
  end

  def show
    @game_ids_names = Game.all.pluck(:id, :name)
    @team_ids_names = Team.all.pluck(:id, :name)
  end

  def update
    flash[:error] = @match.errors.full_messages unless @match.update(match_params)
    redirect_to @match
  end

  def destroy
    @match.destroy
    flash[:success] = "Match deleted"
    redirect_to action: :index
  end

  private

  def load_match
    @match = Match.find(params[:id])
  end

  def match_params
    params.require(:match).permit(
      :played_at,
      :game_id,
      :team_one_id,
      :team_two_id,
      :team_one_score,
      :team_two_score,
    )
  end

  def sanitize_param
    params[:involving_user] &&= params[:involving_user].to_i
  end
end
