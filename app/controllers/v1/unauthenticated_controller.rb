class V1::UnauthenticatedController < ApplicationController
  def index
  end
  def privacy
  end
  def verify
    registration = PhoneNumberRegistration.find_by(verification_code: params[:verification_code])
    if registration
      registration.verification_state = :verified
      registration.save!
    end
    @registered = registration.nil? ? false : true
    render :verify
  end
end
