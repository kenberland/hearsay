ZANG_URL='https://api.zang.io/v2/Accounts'
ZANG_PHONENUMBER='14153583290'

class V2::PhoneNumberRegistrationsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    params[:device_phone_number] = normalize_us_phone_number(params[:device_phone_number])
    result = PhoneNumberRegistration.create! phone_number_registration_params
    result_to_return = result.attributes
    p send_verification_sms(result.device_phone_number, result_to_return.delete('verification_code'))
    render json: result_to_return
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

  def send_verification_sms(destination, verification_code)
    @verification_code = verification_code
    message = render_to_string :sms_message

    if ENV['ZANG_SID']
      auth = { :username => ENV['ZANG_SID'], :password => '' }
      HTTParty.post("#{ZANG_URL}/#{ENV['ZANG_SID']}/SMS/Messages",
                    body: { To: destination,
                            From: ZANG_PHONENUMBER,
                            Body:  message },
                    basic_auth: auth)
    else
      Rails.logger.error message.red
    end
  end
end
