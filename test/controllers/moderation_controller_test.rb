require 'test_helper'
require 'pp'

class ModerationControllerControllerTest < ActionDispatch::IntegrationTest
  test 'all the seed tags need moderation' do
    get '/moderate'
    assert_response 200
    assert_equal(css_select('button.approve').count, 45)
  end

  test 'moderate an approved tag' do
    moderate('approve')
  end

  test 'moderate a rejected tag' do
    moderate('reject')
  end


  def moderate action
    id = (rand*Tag.count).to_int + 1
    assert_equal(Tag::UNMODERATED, Tag.find(id).moderation_state)
    post('/moderate', { tag: { id: id },
                        moderation_action: action},
         {'HTTP_REFERER' => 'http://foo.com'}
        )

    assert_response 302
    assert_equal(Tag.convert_moderation_intent(action),
                 Tag.find(id).moderation_state)
  end
end
