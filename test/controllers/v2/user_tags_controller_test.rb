require 'test_helper'

def my_phone_number
  '12123456789'
end

class V2::UserTagsControllerTest < ActionDispatch::IntegrationTest
  test 'deny tag creation when user is not registered' do
    reg = FactoryGirl.build(:phone_number_registration)
    assert_difference('UserTag.count', 0) do
      xml_http_request(:post,
                       user_tags_url(my_phone_number),
                       parameters = { 'currentUser' => reg.device_uuid, tag: { id: '3' } },
                       headers_or_env = { 'API-VERSION' => 2 }
                      )
      assert_response 400
    end
  end
  test 'deny tag creation when user is not veririfed' do
    reg = FactoryGirl.create(:phone_number_registration)
    assert_difference('UserTag.count', 0) do
      xml_http_request(:post,
                       user_tags_url(my_phone_number),
                       parameters = { 'currentUser' => reg.device_uuid, tag: { id: '3' } },
                       headers_or_env = { 'API-VERSION' => 2 }
                      )
      assert_response 400
    end
  end
  test 'allow tag creation when user is verified' do
    assert_difference('UserTag.count', 1) do
      reg = FactoryGirl.create(:phone_number_registration, :verified)
      xml_http_request(:post,
                       user_tags_url(my_phone_number),
                       parameters = { 'currentUser' => reg.device_uuid, tag: { id: '3' } },
                       headers_or_env = { 'API-VERSION' => 2 }
                      )
      assert_response 200
    end
  end
  test 'disallow tagging yourself' do
    assert_difference('UserTag.count', 0) do
      reg = FactoryGirl.create(:phone_number_registration, :verified)
      xml_http_request(:post,
                       user_tags_url(reg.device_phone_number),
                       parameters = { 'currentUser' => reg.device_uuid, tag: { id: '3' } },
                       headers_or_env = { 'API-VERSION' => 2 }
                      )
      assert_equal('You cannot tag yourself!', response.body)
      assert_response 400
    end
  end
  test 'allow deleting tags the user puts on another user' do
  end
  test 'restore the soft-deleted tag when it is restored' do
  end
  test 'disallow deleting tags the user did not put on another user' do
  end
  test 'allow a user to delete tags that are on them' do
  end
end
