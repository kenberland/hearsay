FactoryGirl.define do
  factory :phone_number_registration do
    device_phone_number '13105551212'
    device_uuid '01234567890abcdef'
    verification_state 0
    trait :verified do
      verification_state PhoneNumberRegistration.verification_states['verified']
    end
  end
end
