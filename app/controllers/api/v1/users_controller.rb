module Api
  module V1
    class UsersController < BaseController
      before_action :authenticate, only: [:show, :update]
      after_action :verify_authorized, only: :update
      expose :user, with: :authorize

      def create
        user.save!
        render json: UserRepresenter.new(user)
      end

      def index
        users = UsersRepository.new.users
        render json: UsersRepresenter.new(users)
      end

      def update
        user.update!(user_params)
        render json: UserRepresenter.new(user)
      end

      private

      def user_params
        params.require(:user).permit(:name, :image, :email, :password, :password_confirmation)
      end
    end
  end
end
