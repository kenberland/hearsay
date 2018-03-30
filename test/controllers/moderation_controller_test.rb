require 'test_helper'
require 'pp'

class ModerationControllerControllerTest < ActionDispatch::IntegrationTest
  test 'all the seed tags need moderation' do
    get '/moderate'
    assert_response 200
    assert_equal(css_select('button.approve').count, 45)
  end
end
