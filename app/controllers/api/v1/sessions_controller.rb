module Api
  module V1
    class SessionsController < ApplicationController
      before_action :ensure_user_not_logged_in!, only: :create

      def create
        user = User.authenticate(params[:email], params[:password])
        if user
          session[:user_id] = user.id
          head :ok
        else
          head 401
        end
      end

      def destroy
        session[:user_id] = nil
        head :ok
      end
    end
  end
end
