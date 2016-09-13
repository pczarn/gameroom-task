class TeamsController < ApplicationController
  def create
    team = Team.create(team_params)
    if team.save
      redirect_to team
    else
      flash[:error] = team.errors.full_messages
      redirect_to action: :index
    end
  end

  def index
    @teams = Team.page(params[:page])
    @new_team = Team.new
  end

  def show
    @team = Team.find(params[:id])
    @user_ids_names = User.all.pluck(:id, :name)
  end

  def update
    team = Team.find(params[:id])
    flash[:error] = team.errors.full_messages unless team.update(team_params)
    redirect_to team
  end

  def destroy
    Team.find(params[:id]).destroy
    flash[:success] = "Team deleted"
    redirect_to action: :index
  end

  def add_member
    # user = User.find(params[:member_id])
    team = Team.find(params[:id])
    user_team = UserTeam.create(team: team, user_id: params[:member_id])
    if user_team.save
      redirect_to team
    else
      flash[:error] = user_team.errors.full_messages
      redirect_to :back
    end
  end

  def remove_member
    UserTeam.find_by(team_id: params[:team_id], user_id: params[:member_id]).destroy
    redirect_to :back
  end

  private

  def team_params
    params.require(:team).permit(
      :name,
    )
  end
end
