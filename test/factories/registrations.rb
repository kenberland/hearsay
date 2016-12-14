# Registration(id: integer, registration_id: string, device_uuid: string, created_at: datetime, updated_at: datetime)
FactoryGirl.define do
  factory :registration do
    device_uuid { SecureRandom.hex[0..15] }

    trait :android do
      registration_id { SecureRandom.hex(32/2) }
    end
    trait :ios do
      registration_id { SecureRandom.hex(64/2) }
    end
  end
end
