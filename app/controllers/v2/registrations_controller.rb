class V2::RegistrationsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    result = Registration.create registration_params
    render json: result
  end

  private

  def registration_params
    params.permit(:device_uuid, :registration_id)
  end
end
