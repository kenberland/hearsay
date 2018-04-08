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
      assert_equal('You cannot tag until you verify your device!',
                   JSON.parse(response.body)['error'])
      assert_response 400
    end
  end
  test 'deny tag creation when user is not verified' do
    reg = FactoryGirl.create(:phone_number_registration)
    params = { 'currentUser' => reg.device_uuid, tag: { id: random_tag } }
    assert_difference('UserTag.count', 0) do
      hearsay_xml_http_request(:post,
                               user_tags_url(target_phone_number),
                               parameters = params
                              )
      assert_equal('You cannot tag until you verify your device!',
                   JSON.parse(response.body)['error'])
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
      assert_equal('You cannot tag yourself!',
                   JSON.parse(response.body)['error'])
      assert_response 400
    end
  end
  test 'disallow tagging yourself when creating a new tag' do
    assert_difference('UserTag.count', 0) do
      reg = FactoryGirl.create(:phone_number_registration, :verified)
      params = {
        'currentUser' => reg.device_uuid,
        tag: {
          newTag: "24k Magic",
          category: "income"
        }
      }
      hearsay_xml_http_request(:post,
                               user_tags_url(reg.device_phone_number),
                               parameters = params
                              )
      assert_equal('You cannot tag yourself!',
                   JSON.parse(response.body)['error'])
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
    assert_difference('UserTag.unscoped.count', 0) do
     params = { 'currentUser' => reg.device_uuid, tag: { id: my_tag } }
      hearsay_xml_http_request(:post,
                       user_tags_url(target_user),
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
  test 'the tag cloud is returned for a user with tags' do
    my_tag = random_tag
    target_user = target_phone_number
    reg = FactoryGirl.create(:phone_number_registration, :verified)
    params = { 'currentUser' => reg.device_uuid, tag: { id: my_tag } }
    hearsay_xml_http_request(:post,
                             user_tags_url(target_user),
                             parameters = params
                            )
    assert_equal(1, JSON.parse(response.body)["tags"].size)
  end
  test 'tags must be at least two characters' do
    tag_category = random_tag_category
    target_user = target_phone_number
    my_tag = '1'
    reg = FactoryGirl.create(:phone_number_registration, :verified)
    params = { 'currentUser' => reg.device_uuid, tag: {
                 newTag: my_tag,
                 category: random_tag_category
               }
             }
    hearsay_xml_http_request(:post,
                             user_tags_url(target_user),
                             parameters = params
                            )
    assert_response 400
    assert_equal('Tag is too short (minimum is 2 characters)',
                 JSON.parse(response.body)['error'])
  end
  test 'tags may be no more than 24 characters' do
    tag_category = random_tag_category
    target_user = target_phone_number
    my_tag = 'X' * 25
    reg = FactoryGirl.create(:phone_number_registration, :verified)
    params = { 'currentUser' => reg.device_uuid, tag: {
                 newTag: my_tag,
                 category: random_tag_category
               }
             }
    hearsay_xml_http_request(:post,
                             user_tags_url(target_user),
                             parameters = params
                            )
    assert_response 400
    assert_equal('Tag is too long (maximum is 24 characters)',
                 JSON.parse(response.body)['error'])
  end
  test 'exactly one new tag is returned when the tag is newly created' do
    tag_category = random_tag_category
    target_user = target_phone_number
    my_tag = Faker::StarWars.character
    reg = FactoryGirl.create(:phone_number_registration, :verified)
    params = { 'currentUser' => reg.device_uuid, tag: {
                 newTag: my_tag,
                 category: random_tag_category
               }
             }
    hearsay_xml_http_request(:post,
                             user_tags_url(target_user),
                             parameters = params
                            )
    assert_equal(Hash, JSON.parse(response.body)["new_tag"].class)
    assert_equal(Tag.last.id, JSON.parse(response.body)["new_tag"]["id"])
  end
  test 'new tag shows it is unmoderated and is_tag_creator=true' do
    tag_category = random_tag_category
    target_user = target_phone_number
    my_tag = Faker::StarWars.character
    reg = FactoryGirl.create(:phone_number_registration, :verified)
    params = { 'currentUser' => reg.device_uuid, tag: {
                 newTag: my_tag,
                 category: random_tag_category
               }
             }
    hearsay_xml_http_request(:post,
                             user_tags_url(target_user),
                             parameters = params
                            )
    assert_equal(true, JSON.parse(response.body)['new_tag']['is_tag_creator'])
    assert_equal('unmoderated', JSON.parse(response.body)['new_tag']['moderation_state'])
  end
  test 'new tag shows it is unmoderated and is_tag_creator=false when another user sees it' do
    tag_category = random_tag_category
    target_user = target_phone_number
    my_tag = Faker::StarWars.character
    reg = FactoryGirl.create(:phone_number_registration, :verified)
    params = { 'currentUser' => reg.device_uuid, tag: {
                 newTag: my_tag,
                 category: random_tag_category
               }
             }
    hearsay_xml_http_request(:post,
                             user_tags_url(target_user),
                             parameters = params
                            )
    other_user = FactoryGirl.create(:phone_number_registration, :verified)
    params = { currentUser: other_user.device_uuid,
               tagsForUsers: [target_user] }
    hearsay_xml_http_request(:post,
                             v3_user_tags_url,
                             parameters = params,
                             '3'
                            )
    assert_response 200
    r = JSON.parse(response.body)
    tag_props = r[target_user]['tags'][Tag.find_by(tag: my_tag).id.to_s]
    assert_equal('unmoderated', tag_props['moderation_state'])
    assert_equal(false, tag_props['is_tag_creator'])
  end
  test 'send is_current_user=true when the tags are requested by the current _user' do
    my_tag = random_tag
    my_target = normalized_fake_number
    target_reg = FactoryGirl.create(:phone_number_registration,
                                    :verified, device_phone_number: my_target)

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
    params = { 'currentUser' => reg2.device_uuid, tag: { id: random_tag } }
    hearsay_xml_http_request(:post,
                             user_tags_url(my_target),
                             parameters = params
                            )
    params = { 'currentUser' => target_reg.device_uuid }
    hearsay_xml_http_request(:get, user_tags_url(my_target), params)
    JSON.parse(response.body)['tags'].each do |tag|
      assert(tag['is_current_user'])
    end
  end
end
