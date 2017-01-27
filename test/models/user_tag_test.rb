require 'test_helper'

class UserTagTest < ActionDispatch::IntegrationTest
  test 'new user_tags create an audit' do
    reg = FactoryGirl.create(:phone_number_registration, :verified)
    params = { 'currentUser' => reg.device_uuid, tag: { id: random_tag } }
    selector = 'UserTag.find_by(from_user_uid: reg.device_uuid).audits.count rescue 0'
    assert_difference(selector, 1) do
      hearsay_xml_http_request(:post,
                               user_tags_url(target_phone_number),
                               parameters = params
                               )
      assert_response 200
    end
  end
  test 'new user_tags create an audit with the phone number of the tagged user' do
    my_target = normalized_fake_number
    reg = FactoryGirl.create(:phone_number_registration, :verified)
    params = { 'currentUser' => reg.device_uuid, tag: { id: random_tag } }
    hearsay_xml_http_request(:post,
                             user_tags_url(my_target),
                             parameters = params
                             )
    audit = UserTag.find_by(from_user_uid: reg.device_uuid).audits.first
    tagged_user = audit.audited_changes["to_user_uid"]
    assert_equal(tagged_user, my_target)
  end
  test 'new user_tags create an audit with the current_user that created the user tag' do
    my_target = target_phone_number
    reg = FactoryGirl.create(:phone_number_registration, :verified)
    params = { 'currentUser' => reg.device_uuid, tag: { id: random_tag } }
    hearsay_xml_http_request(:post,
                             user_tags_url(my_target),
                             parameters = params
                             )
    audit = UserTag.find_by(from_user_uid: reg.device_uuid).audits.first
    assert_equal(audit.username, reg.device_uuid)
  end
  test 'deleted user_tags create an audit' do
    my_tag = random_tag
    target_user = target_phone_number
    tagging_user_reg = FactoryGirl.create(:phone_number_registration, :verified)
    params = { 'currentUser' => tagging_user_reg.device_uuid, tag: { id: my_tag } }
    hearsay_xml_http_request(:post,
                             user_tags_url(target_user),
                             parameters = params
                            )
    params = { 'currentUser' => tagging_user_reg.device_uuid }
    selector = "UserTag.unscoped.find_by(from_user_uid: tagging_user_reg.device_uuid).audits.count rescue 0"
    assert_difference(selector, 1) do
      hearsay_xml_http_request(:delete,
                               user_tag_url(target_user, my_tag),
                               parameters = params
                               )
    end
    audit = UserTag.unscoped.find_by(from_user_uid: tagging_user_reg.device_uuid).audits.last
    assert_equal(audit.action, 'destroy')
  end
  test 'delete user_tags create an audit with the user that deleted the tag' do
    my_tag = random_tag
    target_user = target_phone_number
    tagging_user_reg = FactoryGirl.create(:phone_number_registration, :verified)
    params = { 'currentUser' => tagging_user_reg.device_uuid, tag: { id: my_tag } }
    hearsay_xml_http_request(:post,
                             user_tags_url(target_user),
                             parameters = params
                            )
    params = { 'currentUser' => tagging_user_reg.device_uuid }
    hearsay_xml_http_request(:delete,
                             user_tag_url(target_user, my_tag),
                             parameters = params
                             )
    audit = UserTag.unscoped.find_by(from_user_uid: tagging_user_reg.device_uuid).audits.last
    assert_equal(audit.username, tagging_user_reg.device_uuid)
  end
end
