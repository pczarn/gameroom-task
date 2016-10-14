class UsersController < ApplicationController
  before_action :redirect_if_user_logged_in!, only: [:new, :create]
  before_action :load_user, only: [:edit, :update]
  before_action :verify_authorized, only: [:edit, :update]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to root_path, notice: "Signed up."
    else
      render "new"
    end
  end

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to edit_user_path(@user), notice: "Your account is updated."
    else
      flash.now.alert = @user.errors.full_messages.to_sentence
      render "edit"
    end
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
