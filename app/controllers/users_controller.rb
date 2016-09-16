class UsersController < ApplicationController
  before_action :redirect_if_user_logged_in!

  def new
    @user = User.new
  end

  def create
    @user = User.create(user_params)
    if @user.save
      redirect_to root_path, notice: "Signed up."
    else
      render "new"
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
