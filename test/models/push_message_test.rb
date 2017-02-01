require 'test_helper'

class PushMessageTest < ActiveSupport::TestCase
  test 'to_h returns the right hash' do
    m = PushMessage.new
    m.with_message('Foo')
    m.with_tag('bar')
    m.with_tag_category('baz')
    m.with_seek_to_phone('13105551212')
    assert_equal(m.to_h.class, Hash)
  end
end
