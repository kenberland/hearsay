class V2::PhoneNumberRegistrationsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    result = PhoneNumberRegistration.create phone_number_registration_params
    render json: result
  end

  private

  def phone_number_registration_params
    params.permit(:device_uuid, :device_phone_number)
  end
end
