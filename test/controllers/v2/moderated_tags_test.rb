require 'test_helper'

class V2::ModeratedTagsTest < ActionDispatch::IntegrationTest
  test 'new tag is UNMODERATED when created' do
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
    assert_equal(Tag::moderation_text(Tag.last.moderation_state), JSON.parse(response.body)["new_tag"]["moderation_state"])
    assert_equal(Tag::moderation_text(0), JSON.parse(response.body)["new_tag"]["moderation_state"])
  end

  test "new tag does not have a phone_number_registration because that's an auto-increment and secret" do
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
    assert_equal(nil, JSON.parse(response.body)["new_tag"]["phone_number_registration_id"])
  end
end
