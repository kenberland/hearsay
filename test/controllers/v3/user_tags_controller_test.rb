require 'test_helper'
require 'pp'

class V3::UserTagsControllerTest < ActionDispatch::IntegrationTest
  def setup_scenario
    @n1 = Faker::PhoneNumber.phone_number
    @n2 = Faker::PhoneNumber.phone_number
    @n3 = Faker::PhoneNumber.phone_number

    @user_1 = FactoryGirl.create(
      :phone_number_registration,
      device_phone_number: Phony.normalize(
        chitchatize_number(@n1), cc: '1'))
    @user_2 = FactoryGirl.create(
      :phone_number_registration,
      device_phone_number: Phony.normalize(
        chitchatize_number(@n2), cc: '1'))
    @current_user = FactoryGirl.create(
      :phone_number_registration,
      device_phone_number: Phony.normalize(
        chitchatize_number(@n3), cc: '1'))
    @tag_1 = Tag.all[0]
    @tag_2 = Tag.all[1]
    @tag_3 = Tag.all[2]
    create_tag_mock_post(@tag_1, @user_1, @current_user)
    create_tag_mock_post(@tag_1, @user_2, @current_user)
    create_tag_mock_post(@tag_2, @user_1, @current_user)
    create_tag_mock_post(@tag_3, @user_1, @current_user)
    create_tag_mock_post(@tag_1, @current_user, @user_1)
    create_tag_mock_post(@tag_2, @user_2, @user_1)
    create_tag_mock_post(@tag_3, @user_1, @user_2)
  end

  test 'send registered:true if the user is registered' do
    setup_scenario
    unregistered_user = normalized_fake_number
    verified_user = FactoryGirl.create(
      :phone_number_registration, :verified)
    @tag_1 = Tag.all[0]
    params = { currentUser: @user_1.device_uuid,
               tagsForUsers: [unregistered_user,
                              verified_user.device_phone_number,
                              @user_2.device_phone_number] }
    hearsay_xml_http_request(:post,
                             v3_user_tags_url,
                             parameters = params,
                             '3'
                            )
    r = JSON.parse(response.body)
    assert_equal(true,
                 r[verified_user.device_phone_number]['registered'])
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
    assert_equal(true,
                 tags[@tag_3.id.to_s]['is_current_user']
                )
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
    assert_equal(false,
                 tags[@tag_3.id.to_s]['is_current_user']
                )
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
    assert_equal(2,
                 tags[@tag_1.id.to_s]['count']
                )
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
    assert_equal(true, r[@current_user.device_phone_number]['tags']
                   .collect{ |k, v| v['is_current_user'] }.uniq.first
                )
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
    assert_equal(Hash, JSON.parse(response.body).class)
  end
  test 'the keys are empty for tags we don\'t have' do
    setup_scenario
    empty_number = chitchatize_number(Faker::PhoneNumber.phone_number)
    params = { currentUser: @current_user.device_uuid,
               tagsForUsers: [chitchatize_number(@n1),
                              chitchatize_number(@n2),
                              chitchatize_number(@n3),
                              empty_number] }
    hearsay_xml_http_request(:post,
                             v3_user_tags_url,
                             parameters = params,
                             '3'
                            )
    assert_response 200
    r = JSON.parse(response.body)
    assert_equal({'tags' => [] }, r[empty_number])
  end
end
