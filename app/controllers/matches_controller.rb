class MatchesController < ApplicationController
  before_action :load_match, only: [:edit, :update, :destroy]

  def create
    @match = Match.new(match_params)
    if @match.save
      redirect_to edit_match_path(@match)
    else
      flash[:error] = @match.errors.full_messages
      render "index"
    end
  end

  def index
    @new_match = Match.new(played_at: Time.zone.now)
    @recent = Match.order(played_at: :desc)
    @recent = @recent.involving(params[:involving_user]) if params[:involving_user]
    @recent = @recent.page(params[:page])
  end

  def edit
  end

  def update
    if @match.update(match_params)
      redirect_to edit_match_path(@match)
    else
      flash[:error] = @match.errors.full_messages
      render "edit"
    end
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
end
