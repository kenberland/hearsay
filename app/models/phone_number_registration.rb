class PhoneNumberRegistration < ActiveRecord::Base
    validate :device_phone_number_plausible, on: :create

    def device_phone_number_plausible
      unless Phony.plausible?(self.device_phone_number)
        errors.add(:device_phone_number, 'is not a valid phone number.')
      end
    end
end
