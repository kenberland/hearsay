require 'test_helper'

def target_phone_number
  Faker::PhoneNumber.phone_number.gsub(/\D/,'')
end

def random_tag
  Tag.all[rand*Tag.count].id
end

class TagPushManagerTest < ActionDispatch::IntegrationTest
  test 'reserve returns false when no records are ready for notification' do
    assert_difference("UserTag.where(notification_state: UserTag.notification_states['in_progress']).count", 0) do
      assert_equal(false, TagPushManager.instance.reserve)
    end
  end
  test 'after tagging, reserve returns a record to notify' do
    reg = FactoryGirl.create(:phone_number_registration, :verified)
    params = { 'currentUser' => reg.device_uuid, tag: { id: random_tag } }
    hearsay_xml_http_request(:post,
                             user_tags_url(target_phone_number),
                             parameters = params
                            )
    assert_difference("UserTag.where(notification_state: UserTag.notification_states['in_progress']).count", 1) do
      assert_equal(UserTag, TagPushManager.instance.reserve.class)
    end
  end
end
