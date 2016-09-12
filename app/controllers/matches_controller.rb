class MatchesController < ApplicationController
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
    @new_match = Match.new
    @recent = Match.order(played_at: :desc).limit(10)
    @game_ids_names = Game.all.pluck(:id, :name)
    @team_ids_names = Team.all.pluck(:id, :name)
  end

  def show
    @match = Match.find(params[:id])
    @game_ids_names = Game.all.pluck(:id, :name)
    @team_ids_names = Team.all.pluck(:id, :name)
  end

  def update
    match = Match.find(params[:id])
    flash[:error] = match.errors.full_messages unless match.update(match_params)
    redirect_to match
  end

  def destroy
    Match.find(params[:id]).destroy
    flash[:success] = "Match deleted"
    redirect_to action: :index
  end

  private

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
end
