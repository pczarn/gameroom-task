class ApplicationController < ActionController::Base
  include Pundit
  include Knock::Authenticable

  exposure_config :authorize, decorate: ->(thing) { authorize thing }

  def authorize(record, *params)
    Pundit.instance_method(:authorize).bind(self).call(record, *params)
    record
  end

  private

  def record_not_found
    render file: "#{Rails.root}/public/404", status: :not_found
  end

  def authenticate
    authenticate_user
  end
end
