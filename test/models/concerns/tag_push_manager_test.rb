require 'test_helper'
require 'minitest/mock'

def target_phone_number
  @target_phone_number ||= normalized_fake_number
end

def random_tag
  Tag.all[rand*Tag.count].id
end

class TagPushManagerTest < ActionDispatch::IntegrationTest
  test 'reserve returns false when no records are ready for notification' do
    assert_difference("UserTag.where(notification_state: UserTag.notification_states['in_progress']).count", 0) do
      assert_equal(nil, TagPushManager.new(MiniTest::Mock.new).user_tag)
    end
  end
  test 'after tagging, a push is sent' do
    tagger = FactoryGirl.create(:phone_number_registration, :verified)
    target = FactoryGirl.create(:phone_number_registration, :verified, device_phone_number: target_phone_number)
    target_push_registration = FactoryGirl.create(:registration, :ios, device_uuid: target.device_uuid)
    params = { 'currentUser' => tagger.device_uuid, tag: { id: random_tag } }
    hearsay_xml_http_request(:post,
                             user_tags_url(target_phone_number),
                             parameters = params
                            )
    push_client = MiniTest::Mock.new
    push_client.expect(:push, true, [target_push_registration.registration_id])
    tag_push_manager = TagPushManager.new(push_client)
    tag_push_manager.notify
    push_client.verify
  end
  test 'after tagging, reserve returns a record to notify' do
    reg = FactoryGirl.create(:phone_number_registration, :verified)
    params = { 'currentUser' => reg.device_uuid, tag: { id: random_tag } }
    hearsay_xml_http_request(:post,
                             user_tags_url(target_phone_number),
                             parameters = params
                            )
    assert_difference("UserTag.where(notification_state: UserTag.notification_states['in_progress']).count", 1) do
      assert_equal(UserTag, TagPushManager.new(MiniTest::Mock.new).user_tag.class)
    end
  end
  test 'after tag addition, notification, and then deletion, reserve return a record to notify' do
    my_tag = random_tag
    target_user = target_phone_number
    reg = FactoryGirl.create(:phone_number_registration, :verified)
    params = { 'currentUser' => reg.device_uuid, tag: { id: my_tag } }
    hearsay_xml_http_request(:post,
                             user_tags_url(target_user),
                             parameters = params
                            )
    user_tag = TagPushManager.new(MiniTest::Mock.new).user_tag
    user_tag.update_attribute(:notification_state, :notified)
    params = { 'currentUser' => reg.device_uuid }
    hearsay_xml_http_request(:delete,
                             user_tag_url(target_user, my_tag),
                             parameters = params
                            )
    assert_difference("UserTag.unscoped.where(notification_state: UserTag.notification_states['in_progress']).count", 1) do
      assert_equal(UserTag, TagPushManager.new(MiniTest::Mock.new).user_tag.class)
    end
  end
  test 'after tag addition, notification, and then deletion, a push is sent' do
    tagger = FactoryGirl.create(:phone_number_registration, :verified)
    target = FactoryGirl.create(:phone_number_registration, :verified, device_phone_number: target_phone_number)
    target_push_registration = FactoryGirl.create(:registration, :ios, device_uuid: target.device_uuid)
    my_tag = random_tag
    params = { 'currentUser' => tagger.device_uuid, tag: { id: my_tag } }
    hearsay_xml_http_request(:post,
                             user_tags_url(target_phone_number),
                             parameters = params
                            )
    user_tag = TagPushManager.new(MiniTest::Mock.new).user_tag
    user_tag.update_attribute(:notification_state, :notified)
    params = { 'currentUser' => tagger.device_uuid }
    hearsay_xml_http_request(:delete,
                             user_tag_url(target_phone_number, my_tag),
                             parameters = params
                            )
    push_client = MiniTest::Mock.new
    push_client.expect(:push, true, [target_push_registration.registration_id])
    tag_push_manager = TagPushManager.new(push_client)
    tag_push_manager.notify
    push_client.verify
  end
end
