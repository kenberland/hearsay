require 'test_helper'
require 'pp'

class V3::UserTagsControllerTest < ActionDispatch::IntegrationTest
  def setup_scenario
    @user_1 = FactoryGirl.create(:phone_number_registration)
    @user_2 = FactoryGirl.create(:phone_number_registration)
    @current_user = FactoryGirl.create(:phone_number_registration)
    @tag_1 = Tag.all[0]
    @tag_2 = Tag.all[1]
    @tag_3 = Tag.all[2]
    UserTag.create tag_id: @tag_1.id,
                   from_user_uid: @user_1.device_uuid,
                   to_user_uid: @current_user.device_phone_number
    UserTag.create tag_id: @tag_1.id,
                   from_user_uid: @user_2.device_uuid,
                   to_user_uid: @current_user.device_phone_number

    UserTag.create tag_id: @tag_2.id,
                   from_user_uid: @user_1.device_uuid,
                   to_user_uid: @current_user.device_phone_number
    UserTag.create tag_id: @tag_3.id,
                   from_user_uid: @user_1.device_uuid,
                   to_user_uid: @current_user.device_phone_number

    UserTag.create tag_id: @tag_1.id,
                   from_user_uid: @current_user.device_uuid,
                   to_user_uid: @user_1.device_phone_number

    UserTag.create tag_id: @tag_2.id,
                   from_user_uid: @user_2.device_uuid,
                   to_user_uid: @user_1.device_phone_number

    UserTag.create tag_id: @tag_3.id,
                   from_user_uid: @user_1.device_uuid,
                   to_user_uid: @user_2.device_phone_number
  end
  test 'user_1 can delete the tag she put on user_2' do
    setup_scenario
    params = { currentUser: @user_1.device_uuid,
               tagsForUsers: [@user_2.device_phone_number] }
    hearsay_xml_http_request(:post,
                             v3_user_tags_url,
                             parameters = params,
                             '3'
                            )
    assert_response 200
    r = JSON.parse(response.body)
    tags = r[@user_2.device_phone_number]['tags']
    assert_equal(tags[@tag_3.id.to_s]['is_current_user'],
                 true)
  end
  test 'current user cannot delete the tag user_1 put on user_2' do
    setup_scenario
    params = { currentUser: @current_user.device_uuid,
               tagsForUsers: [@user_2.device_phone_number] }
    hearsay_xml_http_request(:post,
                             v3_user_tags_url,
                             parameters = params,
                             '3'
                            )
    assert_response 200
    r = JSON.parse(response.body)
    tags = r[@user_2.device_phone_number]['tags']
    assert_equal(tags[@tag_3.id.to_s]['is_current_user'],
                 false)
  end
  test 'the count on tags is correct' do
    setup_scenario
    params = { currentUser: @current_user.device_uuid,
               tagsForUsers: [@current_user.device_phone_number] }
    hearsay_xml_http_request(:post,
                             v3_user_tags_url,
                             parameters = params,
                             '3'
                            )
    assert_response 200
    r = JSON.parse(response.body)
    tags = r[@current_user.device_phone_number]['tags']
    assert_equal(tags[@tag_1.id.to_s]['count'],
                 2)
  end
  test 'all the tags on the current user are deleteable' do
    setup_scenario
    params = { currentUser: @current_user.device_uuid,
               tagsForUsers: [@user_1.device_phone_number,
                              @user_2.device_phone_number,
                              @current_user.device_phone_number] }
    hearsay_xml_http_request(:post,
                             v3_user_tags_url,
                             parameters = params,
                             '3'
                            )
    assert_response 200
    r = JSON.parse(response.body)
    assert_equal(r[@current_user.device_phone_number]['tags']
                   .collect{ |k, v| v['is_current_user'] }.uniq.first,
                 true)
  end
  test 'the v3 tag cloud is well formed' do
    setup_scenario
    params = { currentUser: @current_user.device_uuid,
               tagsForUsers: [@user_1.device_phone_number,
                              @user_2.device_phone_number,
                              @current_user.device_phone_number] }
    hearsay_xml_http_request(:post,
                             v3_user_tags_url,
                             parameters = params,
                             '3'
                            )
    assert_response 200
    assert_equal(JSON.parse(response.body).class, Hash)
  end
end
