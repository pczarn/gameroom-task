module ExceptionsHandler
  extend ActiveSupport::Concern

  included do
    rescue_from StandardError, with: :error_occured
    rescue_from Pundit::NotAuthorizedError, with: :not_authorized
    rescue_from ActiveRecord::RecordInvalid, with: :record_invalid
    rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  end

  protected

  def not_authorized(exception)
    render json: { error: { message: exception.message } }, status: 403
  end

  def record_invalid(exception)
    field_messages = {}
    exception.record.errors.keys.each do |field|
      field_messages[field] = exception.record.errors.full_messages_for(field)
    end
    error = { message: exception.message, field_messages: field_messages }
    render json: { error: error }, status: 422
  end

  def record_not_found
    render json: { error: { message: "Record not found" } }, status: 404
  end

  def error_occured(exception)
    raise exception if Rails.env.development? || Rails.env.test?
    render json: { error: { message: "Something went wrong" } }, status: 500
  end
end
