class ContactsController < ApplicationController
  before_action :set_current_user
  before_action :require_logged_in

  def index
    render json: Contact.serialize(@current_user.contacts), status: :ok
  end

  def show
    result = Contact.find_by_id params[:contact_id]
    render json: not_found_error, status: :not_found and return if result.nil?
    render json: Contact.serialize(result), status: :ok
  end

  def update
    contact_id = params[:contact_id]
    contact = Contact.update contact_id, contact_params
    render json: not_found_error, status: :not_found and return unless contact
    render json: Contact.serialize(contact), status: :ok
  end

  def destroy
    
  end

  def create
    contact = Contact.instance contact_params, social_networks, @current_user
    unless contact[:okay]
      render json: error_builder(contact[:payload]), status: :unprocessable_entity and return
    end
    render json: Contact.serialize(contact[:payload]), status: :ok
  end

  private

  def contact_params
    params[:contact].permit :name, :email, :address, :phone
  end

  def social_networks
    params[:contact].permit(social_networks: %i[type url number])[:social_networks]
  end
end