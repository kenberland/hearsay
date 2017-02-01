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
    selector = "Audited::Audit.where(notification_state: TagPushManager::IN_PROGRESS).count"
    assert_difference(selector, 0) do
      assert_equal(nil, TagPushManager.new(MiniTest::Mock.new).user_tag)
    end
  end
  test 'after tagging, a push is sent' do
    tagger = FactoryGirl.create(:phone_number_registration, :verified)
    target = FactoryGirl.create(:phone_number_registration, :verified, device_phone_number: target_phone_number)
    target_push_registration = FactoryGirl.create(:registration, :ios, device_uuid: target.device_uuid)
    my_tag = random_tag
    params = { 'currentUser' => tagger.device_uuid, tag: { id: my_tag } }
    hearsay_xml_http_request(:post,
                             user_tags_url(target_phone_number),
                             parameters = params
                            )
    push_client = MiniTest::Mock.new
    push_message = PushMessage.new
      .with_message(I18n.t('tag-messages.tagged'))
      .with_tag(Tag.find(my_tag).tag)
      .with_seek_to_phone(target_phone_number)
    push_client.expect(:push, true, [
                                     target_push_registration.registration_id,
                                     push_message
                                    ])
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
    assert_difference("Audited::Audit.where(notification_state: TagPushManager::IN_PROGRESS).count", 1) do
      assert_equal(Audited::Audit, TagPushManager.new(MiniTest::Mock.new).user_tag.class)
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
    user_tag.update_attribute(:notification_state, TagPushManager::NOTIFIED)
    params = { 'currentUser' => reg.device_uuid }
    hearsay_xml_http_request(:delete,
                             user_tag_url(target_user, my_tag),
                             parameters = params
                            )
    assert_difference("Audited::Audit.where(notification_state: TagPushManager::IN_PROGRESS).count", 1) do
      assert_equal(Audited::Audit, TagPushManager.new(MiniTest::Mock.new).user_tag.class)
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
    push_client = MiniTest::Mock.new
    user_tag = TagPushManager.new(push_client).user_tag
    user_tag.update_attribute(:notification_state, TagPushManager::NOTIFIED)
    params = { 'currentUser' => tagger.device_uuid }
    hearsay_xml_http_request(:delete,
                             user_tag_url(target_phone_number, my_tag),
                             parameters = params
                            )
    push_client = MiniTest::Mock.new
    push_message = PushMessage.new
      .with_message(I18n.t('tag-messages.untagged'))
      .with_tag(Tag.find(my_tag).tag)
      .with_seek_to_phone(target_phone_number)
    push_client.expect(:push, true, [
                                     target_push_registration.registration_id,
                                     push_message
                                    ])
    tag_push_manager = TagPushManager.new(push_client)
    tag_push_manager.notify
    push_client.verify
  end
  test 'sends your tag has been removed' do
    tagger = FactoryGirl.create(:phone_number_registration, :verified)
    target = FactoryGirl.create(:phone_number_registration, :verified, device_phone_number: target_phone_number)
    tagger_push_registration = FactoryGirl.create(:registration, :android, device_uuid: tagger.device_uuid)
    target_push_registration = FactoryGirl.create(:registration, :ios, device_uuid: target.device_uuid)
    my_tag = random_tag
    params = { 'currentUser' => tagger.device_uuid, tag: { id: my_tag } }
    hearsay_xml_http_request(:post,
                             user_tags_url(target_phone_number),
                             parameters = params
                            )
    push_client = MiniTest::Mock.new
    user_tag = TagPushManager.new(push_client).user_tag
    user_tag.update_attribute(:notification_state, TagPushManager::NOTIFIED)
    params = { 'currentUser' => target.device_uuid }
    hearsay_xml_http_request(:delete,
                             user_tag_url(target_phone_number, my_tag),
                             parameters = params
                            )
    push_client = MiniTest::Mock.new
    push_message = PushMessage.new
      .with_message(I18n.t('tag-messages.removed'))
      .with_tag(Tag.find(my_tag).tag)
      .with_seek_to_phone(target_phone_number)
    push_client.expect(:push, true, [
                                     tagger_push_registration.registration_id,
                                     push_message
                                    ])
    tag_push_manager = TagPushManager.new(push_client)
    tag_push_manager.notify
    push_client.verify
  end
  test 'Tag war. After tag addition, deletion, and re-addition, a push is sent' do
    tagger = FactoryGirl.create(:phone_number_registration, :verified)
    target = FactoryGirl.create(:phone_number_registration, :verified, device_phone_number: target_phone_number)
    target_push_registration = FactoryGirl.create(:registration, :ios, device_uuid: target.device_uuid)
    my_tag = random_tag
    params = { 'currentUser' => tagger.device_uuid, tag: { id: my_tag } }
    hearsay_xml_http_request(:post,
                             user_tags_url(target_phone_number),
                             parameters = params
                            )
    push_client = MiniTest::Mock.new
    user_tag = TagPushManager.new(push_client).user_tag
    user_tag.update_attribute(:notification_state, TagPushManager::NOTIFIED)
    params = { 'currentUser' => tagger.device_uuid }
    hearsay_xml_http_request(:delete,
                             user_tag_url(target_phone_number, my_tag),
                             parameters = params
                            )
    push_client = MiniTest::Mock.new
    user_tag = TagPushManager.new(push_client).user_tag
    user_tag.update_attribute(:notification_state, TagPushManager::NOTIFIED)

    params = { 'currentUser' => tagger.device_uuid, tag: { id: my_tag } }
    hearsay_xml_http_request(:post,
                             user_tags_url(target_phone_number),
                             parameters = params
                            )
    push_client = MiniTest::Mock.new
    push_message = PushMessage.new
      .with_message(I18n.t('tag-messages.tagged'))
      .with_tag(Tag.find(my_tag).tag)
      .with_seek_to_phone(target_phone_number)
    push_client.expect(:push, true, [
                                     target_push_registration.registration_id,
                                     push_message
                                    ])
    tag_push_manager = TagPushManager.new(push_client)
    tag_push_manager.notify
    push_client.verify
  end
  test "Don't blow up when the phone number is not registered" do
    tagger = FactoryGirl.create(:phone_number_registration, :verified)
    target_phone = '1646' # BOGUS
    my_tag = random_tag
    params = { 'currentUser' => tagger.device_uuid, tag: { id: my_tag } }
    hearsay_xml_http_request(:post,
                             user_tags_url(target_phone_number),
                             parameters = params
                            )
    push_client = PushClient.new
    tag_push_manager = TagPushManager.new(push_client)
    tag_push_manager.notify
    assert_equal(tag_push_manager.user_tag.notification_state,
                 TagPushManager::UNNOTIFIABLE)
  end
  test "Don't blow up when the device doesn't have a push id" do
    tagger = FactoryGirl.create(:phone_number_registration, :verified)
    target = FactoryGirl.create(:phone_number_registration, :verified,
                                device_phone_number: target_phone_number)
    tagger_push_registration = FactoryGirl
                               .create(:registration, :android,
                                       device_uuid: tagger.device_uuid)
    my_tag = random_tag
    params = { 'currentUser' => tagger.device_uuid, tag: { id: my_tag } }
    hearsay_xml_http_request(:post,
                             user_tags_url(target_phone_number),
                             parameters = params
                            )
    push_client = PushClient.new
    tag_push_manager = TagPushManager.new(push_client)
    tag_push_manager.notify
    assert_equal(tag_push_manager.user_tag.notification_state,
                 TagPushManager::UNNOTIFIABLE)
  end
end
