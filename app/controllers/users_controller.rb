class UsersController < ApplicationController
  before_action :ensure_user_not_logged_in!
  before_action :load_user, only: [:show, :update]
  before_action :verify_authorized, only: :update

  def create
    user = User.create!(user_params)
    render json: UserRepresenter.new(user)
  end

  def show
    render json: UserRepresenter.new(@user)
  end

  def update
    @user.update!(user_params)
    render json: UserRepresenter.new(@user)
  end

  private

  def load_user
    @user = User.find(params[:id])
    authorize @user
  end

  def user_params
    params.require(:user).permit(:name, :image, :email, :password, :password_confirmation)
  end
end
