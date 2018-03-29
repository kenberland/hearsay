require 'test_helper'

class TagTest < ActiveSupport::TestCase
  test 'new tag is in an unmoderated state' do
    tc = TagCategory.all[rand*TagCategory.count]
    tag = Tag.find_or_create_by({ tag: Faker::StarWars.character,
                            tag_category: tc }) rescue ActiveRecord::RecordNotUnique
    assert_equal(tag.is_unmoderated, true)
  end
end
