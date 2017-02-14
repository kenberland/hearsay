class PhoneNumberRegistration < ActiveRecord::Base
    enum verification_state: [:unverified, :verified]
#    validate :device_phone_number_plausible, on: :create
    before_create :create_verification_code

    def device_phone_number_plausible
      unless Phony.plausible?(self.device_phone_number)
        errors.add(:device_phone_number, " #{self.device_phone_number} is not a valid phone number.")
      end
    end

    private

    def create_verification_code
      self.verification_code = SecureRandom.urlsafe_base64
    end
end
