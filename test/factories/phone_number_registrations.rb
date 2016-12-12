FactoryGirl.define do
  factory :phone_number_registration do
    device_phone_number { Phony.normalize(Faker::PhoneNumber.phone_number, cc: '1')[0..10] }
    device_uuid { SecureRandom.hex[0..15] }
    verification_state 0
    trait :verified do
      verification_state PhoneNumberRegistration.verification_states['verified']
    end
  end
end
