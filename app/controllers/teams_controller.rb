class TeamsController < ApplicationController
  before_action :authenticate!
  before_action :load_team, only: [:show, :update, :destroy]

  def create
    team = Team.new(team_params)
    if team.save
      redirect_to team
    else
      flash.now.alert = team.errors.full_messages.to_sentence
      render "index"
    end
  end

  def index
    @teams = Team.page(params[:page])
    @team = Team.new
  end

  def show
  end

  def update
    if @team.update(team_params)
      redirect_to @team
    else
      flash.now.alert = @team.errors.full_messages
      render "show"
      # redirect_to @team
    end
  end

  def destroy
    @team.destroy
    flash.notice = "Team deleted"
    redirect_to action: :index
  end

  def add_member
    @team = Team.find(params[:team_id])
    user_team = @team.members << User.find(params[:member_id])
    if @team.save
      redirect_to @team
    else
      # still saves
      flash.alert = @team.errors.full_messages.to_sentence
      redirect_to @team
    end
  end

  def remove_member
    @team = Team.find(params[:team_id])
    if @team.members.size >= 2
      UserTeam.find_by(team: @team, user_id: params[:member_id]).destroy!
    else
      flash.alert = "Cannot remove the only user from a team"
      # cannot render here? why?
    end
    redirect_to @team
  end

  private

  def load_team
    @team = Team.find(params[:id])
  end

  def team_params
    params.require(:team).permit(
      :name,
    )
  end
end
