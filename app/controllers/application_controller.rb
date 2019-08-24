class ApplicationController < ActionController::API
  private

  def set_current_user
    @current_user = User.find_by_api_key request.headers["X-API-Key"]
  end

  def require_logged_in
    render json: auth_error, status: :unauthorized if @current_user.nil?
  end

  def error_builder(errors, status = 422)
    { status: status, errors: errors || [] }.to_json
  end

  def auth_error(msg = 'No autorizado')
    error_builder([{ detail: msg }], 401)
  end

  def not_found_error
    error_builder([{ detail: 'Recurso no encontrado' }], 404)
  end
end
