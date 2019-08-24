class UserProfilesController < ApplicationController
  before_action :set_current_user
  before_action :require_logged_in
  before_action :set_profile

  def my_profile
    render json: @current_user.info, status: :ok
  end

  def update
    new_email = params[:user][:email]
    unless new_email.nil?
      unless @current_user.update email: new_email
        render json: error_builder(@current_user.error_msgs), status: :unprocessable_entity and return
      end
    end
    unless @profile.update profile_params
      render json: error_builder(@profile.error_msgs), status: :unprocessable_entity and return
    end
    render json: @current_user.info, status: :ok
  end

  private

  def profile_params
    params[:user].permit :name, :address, :phone
  end

  def set_profile
    @profile = @current_user.user_profile
  end
end