require 'test_helper'

class V2::UserTagsControllerTest < ActionDispatch::IntegrationTest
  test "deny tag creation when user is not registered" do
    reg = FactoryGirl.build(:phone_number_registration)
    xml_http_request(:post,
                     user_tags_url(reg.device_phone_number),
                     parameters = { 'currentUser' => reg.device_uuid, tag: { id: '3' } },
                     headers_or_env = { 'API-VERSION' => 2 }
                    )
    assert_response 400
  end
  test "deny tag creation when user is not veririfed" do
    reg = FactoryGirl.create(:phone_number_registration)
    xml_http_request(:post,
                     user_tags_url(reg.device_phone_number),
                     parameters = { 'currentUser' => reg.device_uuid, tag: { id: '3' } },
                     headers_or_env = { 'API-VERSION' => 2 }
                    )
    assert_response 400
  end
  test "allow tag creation when user is verified" do
    reg = FactoryGirl.create(:phone_number_registration, :verified)
    xml_http_request(:post,
                     user_tags_url(reg.device_phone_number),
                     parameters = { 'currentUser' => reg.device_uuid, tag: { id: '3' } },
                     headers_or_env = { 'API-VERSION' => 2 }
                    )
    assert_response 400
  end
end
