class SessionsController < ApplicationController
  before_action :set_current_user, only: %i[destroy]
  before_action :require_logged_in, only: %i[destroy]

  def create
    auth = auth_params
    user = User.auth auth[:email], auth[:password]
    render json: auth_error('Credenciales invalidas'), status: :unauthorized and return unless user
    render json: user.info, status: :ok
  end

  def destroy
    render json: auth_error, status: :unauthorized unless @current_user.logout
    render json: {}, status: :ok
  end

  private

  def auth_params
    params[:user].permit :email, :password
  end

end