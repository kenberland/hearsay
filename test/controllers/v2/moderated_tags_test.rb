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
    debugger;1
    assert_equal(Hash, JSON.parse(response.body)["new_tag"].class)
    assert_equal(Tag.last.id, JSON.parse(response.body)["new_tag"]["id"])
  end
end
