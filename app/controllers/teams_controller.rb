class TeamsController < ApplicationController
  before_action :authenticate!
  before_action :load_team, only: [:edit, :update, :destroy, :add_member, :remove_member]
  before_action :expect_team_owner!, only: [:update, :destroy, :add_member, :remove_member]

  def create
    @team = Team.new(team_params.merge(members: [current_user]))
    if @team.save
      @team.user_teams.find_by(user: current_user).owner!
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

  def destroy
    @team.destroy
    flash.notice = "Team deleted"
    redirect_to teams_path
  end

  def add_member
    @team = Team.find(params[:team_id])
    @team.members << User.find(params[:member_id])
    flash.alert = @team.errors.full_messages.to_sentence unless @team.save
    redirect_back fallback_location: edit_team_path(@team)
  end

  def remove_member
    @team = Team.find(params[:team_id])
    owners = @team.user_teams.where(role: :owner).where.not(user_id: params[:member_id]).count
    if owners >= 1
      user_team = @team.user_teams.find_by(user_id: params[:member_id])
      user_team.destroy!
    else
      flash.alert = "Cannot remove the only owner from a team"
    end
    redirect_back fallback_location: edit_team_path(@team)
  end

  private

  def load_team
    @team = Team.find(params[:id] || params[:team_id])
  end

  def team_params
    params.require(:team).permit(
      :name,
    )
  end

  def expect_team_owner!
    return if current_user && @team.owned_by?(current_user)
    redirect_back fallback_location: teams_path, alert: "You are not the owner."
  end
end
