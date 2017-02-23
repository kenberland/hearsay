require 'test_helper'
require 'pp'

class V3::UserTagsControllerTest < ActionDispatch::IntegrationTest
  def setup_scenario
    @n1 = plausible_fake_number
    @n2 = plausible_fake_number
    @n3 = plausible_fake_number

    @n1_1 = Phony.normalize(
      chitchatize_number(@n1), cc: '1')
    @n2_1 = Phony.normalize(
      chitchatize_number(@n2), cc: '1')
    @n3_1 = Phony.normalize(
      chitchatize_number(@n3), cc: '1')

    @user_1 = FactoryGirl.create(
      :phone_number_registration,
      device_phone_number: @n1_1)
    @user_2 = FactoryGirl.create(
      :phone_number_registration,
      device_phone_number: @n2_1)
    @current_user = FactoryGirl.create(
      :phone_number_registration,
      device_phone_number: @n3_1)
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

  test 'send registered:false if all the users are not registered' do
    setup_scenario
    unregistered_user1 = chitchatize_number plausible_fake_number
    unregistered_user2 = chitchatize_number plausible_fake_number
    params = { currentUser: @user_1.device_uuid,
               tagsForUsers: [unregistered_user1,
                              unregistered_user2
                             ]
             }
    hearsay_xml_http_request(:post,
                             v3_user_tags_url,
                             parameters = params,
                             '3'
                            )
    r = JSON.parse(response.body)
    assert_equal( [false, false],
                 [ r[unregistered_user1]['registered'],
                   r[unregistered_user2]['registered']
                 ])
  end

  test 'send the right registered if 2 users are not registered and one is' do
    setup_scenario
    unregistered_user1 = chitchatize_number plausible_fake_number
    unregistered_user2 = chitchatize_number plausible_fake_number
    verified_user = FactoryGirl.create(
      :phone_number_registration, :verified)
    params = { currentUser: @user_1.device_uuid,
               tagsForUsers: [unregistered_user1,
                              unregistered_user2,
                              verified_user.device_phone_number
                             ]
             }
    hearsay_xml_http_request(:post,
                             v3_user_tags_url,
                             parameters = params,
                             '3'
                            )
    r = JSON.parse(response.body)
    assert_equal( [false, false, true],
                 [ r[unregistered_user1]['registered'],
                   r[unregistered_user2]['registered'],
                   r[verified_user.device_phone_number]['registered'],
                 ])
  end

  test 'send registered:true if the user is registered' do
    setup_scenario
    unregistered_user = normalized_fake_number
    verified_user = FactoryGirl.create(
      :phone_number_registration, :verified)
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

  test 'registration hash has the phone number the client sent, not the normalized one' do
    setup_scenario
    phone_number = '(310) 373-7981'
    chitchatized_number = chitchatize_number(phone_number)
    normalized_number = Phony.normalize(phone_number, cc: '1')
    verified_user = FactoryGirl.create(:phone_number_registration,
                                        :verified,
                                        device_phone_number: normalized_number)
    params = { currentUser: @user_1.device_uuid,
               tagsForUsers: [chitchatized_number,
                              @user_2.device_phone_number]
             }
    hearsay_xml_http_request(:post,
                             v3_user_tags_url,
                             parameters = params,
                             '3'
                            )
    r = JSON.parse(response.body)
    assert_equal(true, r[chitchatized_number]['registered'])
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
    assert_equal({'tags' => [], 'registered' => false }, r[empty_number])
  end
end
