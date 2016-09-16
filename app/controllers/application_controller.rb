class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  helper_method :current_user

  private

  def authenticate!
    redirect_to log_in_path unless session[:user_id]
  end

  def redirect_if_user_logged_in!
    redirect_to root_path, notice: "You are already logged in." if session[:user_id]
  end

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  rescue
    session[:user_id] = nil
  end
end
