class UsersController < ApplicationController
  def create
    user = User.instance user_params, profile_params
    unless user[:okay]
      render json: error_builder(user[:payload]), status: :unprocessable_entity and return
    end
    render json: user[:payload].info, status: :ok
  end

  private

  def user_params
    return {} if params[:user].nil?
    params[:user].permit :email, :password, :password_confirmation
  end

  def profile_params
    return {} if params[:user].nil?
    params[:user].permit :name, :address, :phone
  end
end