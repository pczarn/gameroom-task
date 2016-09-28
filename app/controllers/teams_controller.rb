class TeamsController < ApplicationController
  before_action :authenticate!
  before_action :load_team, only: [:edit, :update]
  before_action :expect_team_member!, only: :update

  def create
    @team = Team.new(team_params)
    if @team.save
      redirect_to edit_team_path(@team)
    else
      flash.now.alert = @team.errors.full_messages.to_sentence
      @teams = Team.page(params[:page])
      render "index"
    end
  end

  def index
    @teams = Team.page(params[:page])
    @team = Team.new
  end

  def edit
  end

  def update
    if @team.update(team_params)
      redirect_to edit_team_path(@team)
    else
      flash.now.alert = @team.errors.full_messages
      render "edit"
    end
  end

  private

  def load_team
    @team = Team.find(params[:id])
  end

  def team_params
    params.require(:team).permit(:name, member_ids: [])
  end

  def expect_team_member!
    return if current_user && @team.member_ids.include?(current_user.id)
    redirect_back fallback_location: teams_path, alert: "You are not a member of this team."
  end
end
