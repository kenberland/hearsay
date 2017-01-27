require 'test_helper'

class V2::UserTagsControllerTest < ActionDispatch::IntegrationTest
  test 'deny tag creation when user is not registered' do
    reg = FactoryGirl.build(:phone_number_registration)
    params = { 'currentUser' => reg.device_uuid, tag: { id: random_tag } }
    assert_difference('UserTag.count', 0) do
      hearsay_xml_http_request(:post,
                               user_tags_url(target_phone_number),
                               parameters = params
                              )
      assert_equal('You cannot tag until you verify your device!', response.body)
      assert_response 400
    end
  end
  test 'deny tag creation when user is not veririfed' do
    reg = FactoryGirl.create(:phone_number_registration)
    params = { 'currentUser' => reg.device_uuid, tag: { id: random_tag } }
    assert_difference('UserTag.count', 0) do
      hearsay_xml_http_request(:post,
                               user_tags_url(target_phone_number),
                               parameters = params
                              )
      assert_equal('You cannot tag until you verify your device!', response.body)
      assert_response 400
    end
  end
  test 'allow tag creation when user is verified' do
    assert_difference('UserTag.count', 1) do
      reg = FactoryGirl.create(:phone_number_registration, :verified)
      params = { 'currentUser' => reg.device_uuid, tag: { id: random_tag } }
      hearsay_xml_http_request(:post,
                       user_tags_url(target_phone_number),
                       parameters = params
                      )
      assert_response 200
    end
  end
  test 'disallow tagging yourself' do
    assert_difference('UserTag.count', 0) do
      reg = FactoryGirl.create(:phone_number_registration, :verified)
      params = { 'currentUser' => reg.device_uuid, tag: { id: random_tag } }
      hearsay_xml_http_request(:post,
                               user_tags_url(reg.device_phone_number),
                               parameters = params
                              )
      assert_equal('You cannot tag yourself!', response.body)
      assert_response 400
    end
  end
  test 'allow deleting tags the user puts on another user' do
    my_tag = random_tag
    target_user = target_phone_number
    reg = FactoryGirl.create(:phone_number_registration, :verified)
    params = { 'currentUser' => reg.device_uuid, tag: { id: my_tag } }
    hearsay_xml_http_request(:post,
                             user_tags_url(target_user),
                             parameters = params
                            )
    params = { 'currentUser' => reg.device_uuid }
    assert_difference('UserTag.count', -1) do
      hearsay_xml_http_request(:delete,
                               user_tag_url(target_user, my_tag),
                               parameters = params
                              )
    end
  end
  test 'deleting a tag actually soft deletes it' do
    my_tag = random_tag
    target_user = target_phone_number
    reg = FactoryGirl.create(:phone_number_registration, :verified)
    params = { 'currentUser' => reg.device_uuid, tag: { id: my_tag } }
    hearsay_xml_http_request(:post,
                             user_tags_url(target_user),
                             parameters = params
                            )
    params = { 'currentUser' => reg.device_uuid }
    assert_difference('UserTag.unscoped.count', 0) do
      hearsay_xml_http_request(:delete,
                               user_tag_url(target_user, my_tag),
                               parameters = params
                              )
    end
  end
  test 'disallow deleting tags the user did not put on another user' do
    my_tag = random_tag
    target_user = target_phone_number
    tagging_user = FactoryGirl.create(:phone_number_registration, :verified)
    other_user = FactoryGirl.create(:phone_number_registration, :verified)
    params = { 'currentUser' => tagging_user.device_uuid, tag: { id: my_tag } }
    hearsay_xml_http_request(:post,
                             user_tags_url(target_user),
                             parameters = params
                            )
    params = { 'currentUser' => other_user.device_uuid }
    assert_difference('UserTag.count', 0) do
      hearsay_xml_http_request(:delete,
                               user_tag_url(target_user, my_tag),
                               parameters = params
                              )
    end
  end
  test 'restore the soft-deleted tag when it is re-added' do
    my_tag = random_tag
    target_user = target_phone_number
    reg = FactoryGirl.create(:phone_number_registration, :verified)
    params = { 'currentUser' => reg.device_uuid, tag: { id: my_tag } }
    hearsay_xml_http_request(:post,
                             user_tags_url(target_user),
                             parameters = params
                            )
    params = { 'currentUser' => reg.device_uuid }
    hearsay_xml_http_request(:delete,
                             user_tag_url(target_user, my_tag),
                             parameters = params
                             )
    assert_difference('UserTag.count', 1) do 
     params = { 'currentUser' => reg.device_uuid, tag: { id: my_tag } }
      hearsay_xml_http_request(:post,
                       user_tags_url(target_phone_number),
                               parameters = params
                               )
      assert_response 200
    end
  end
  test 'allow a user to delete a tag on themself, deleting all the tags from all the users who put that shit there' do
    my_tag = random_tag
    my_target = target_phone_number
    target_reg = FactoryGirl.create(:phone_number_registration, :verified, device_phone_number: my_target)

    reg = FactoryGirl.create(:phone_number_registration, :verified)
    params = { 'currentUser' => reg.device_uuid, tag: { id: my_tag } }
    hearsay_xml_http_request(:post,
                       user_tags_url(my_target),
                       parameters = params
                      )
    reg2 = FactoryGirl.create(:phone_number_registration, :verified)
    params = { 'currentUser' => reg2.device_uuid, tag: { id: my_tag } }
    hearsay_xml_http_request(:post,
                             user_tags_url(my_target),
                             parameters = params
                      )
    assert_equal(UserTag.count, 2)
    params = { 'currentUser' => target_reg.device_uuid }
    assert_difference('UserTag.count', -2) do
      hearsay_xml_http_request(:delete,
                               user_tag_url(my_target, my_tag),
                               parameters = params
                              )
    end
  end
end
