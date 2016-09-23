class TeamsController < ApplicationController
  before_action :authenticate!
  before_action :load_team, only: [:show, :update, :destroy]
  before_action :load_team_2, only: [:add_member, :remove_member]
  before_action :expect_team_owner!, only: [:update, :destroy, :add_member, :remove_member]

  def create
    @team = Team.new(team_params.merge(members: [current_user]))
    @team.user_teams.build(user: current_user, role: :owner)
    if @team.save
      redirect_to @team
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

  def show
  end

  def update
    if @team.update(team_params)
      redirect_to @team
    else
      flash.now.alert = @team.errors.full_messages
      render "show"
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
    unless @team.save
      flash.alert = @team.errors.full_messages.to_sentence
    end
    redirect_to @team
  end

  def remove_member
    @team = Team.find(params[:team_id])
    owners = @team.user_teams.where(role: :owner).where.not(user_id: params[:member_id]).count
    if owners >= 1
      user_team = @team.user_teams.find_by(user_id: params[:member_id])
      user_team.destroy!
    else
      flash.alert = "Cannot remove the only owner from a team"
      # cannot render here? why? there is team_id but no id
    end
    redirect_to @team
  end

  private

  def load_team
    @team = Team.find(params[:id])
  end

  def load_team_2
    @team = Team.find(params[:team_id])
  end

  def team_params
    params.require(:team).permit(
      :name,
    )
  end

  def expect_team_owner!
    user_team = UserTeam.find_by(user: current_user, team: @team) if current_user
    redirect_to teams_path, alert: "You are not the owner." unless user_team && user_team.owner?
  end
end
