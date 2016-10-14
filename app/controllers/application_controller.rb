class ApplicationController < ActionController::Base
  include Pundit

  protect_from_forgery with: :exception

  helper_method :current_user

  def authorize(record, *params)
    Pundit.instance_method(:authorize).bind(self).(record, *params)
    record
  end

  private

  def record_not_found
    render file: "#{Rails.root}/public/404", status: :not_found
  end

  def authenticate!
    render json: { error: "forbidden" }, status: :forbidden unless session[:user_id]
  end

  def ensure_user_not_logged_in!
    render json: { error: "forbidden" }, status: :forbidden if session[:user_id]
  end

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  rescue
    session[:user_id] = nil
  end
end
