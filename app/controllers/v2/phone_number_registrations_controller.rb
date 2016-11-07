class V2::PhoneNumberRegistrationsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    params[:device_phone_number] = normalize_us_phone_number(params[:device_phone_number])
    result = PhoneNumberRegistration.create! phone_number_registration_params
    render json: result
  rescue ActiveRecord::RecordInvalid => e
    render json: { error: { RecordInvalid: e.record.errors } }, status: 400
  end

  private

  def normalize_us_phone_number(number)
    Phony.normalize(number, cc: '1')
  rescue Phony::NormalizationError => e
    nil
  end

  def phone_number_registration_params
    params.permit(:device_uuid, :device_phone_number)
  end
end
