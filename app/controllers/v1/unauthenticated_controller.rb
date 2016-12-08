class V1::UnauthenticatedController < ApplicationController
  def index
  end
  def privacy
  end
  def show
    @registration = PhoneNumberRegistration.find_by(verification_code: params[:verification_code])
    render :verify_show
  end
  def update
    registration = PhoneNumberRegistration.find_by(verification_code: params[:verification_code])
    if registration
      registration.verification_state = :verified
      registration.save!
    end
    @registered = registration.nil? ? false : true
    render :verify_update
  end
end
