class V2::TagsController < ApplicationController

  def index
    tags = Tag.joins(:tag_category)
      .pluck(:id, :tag, 'tag_categories.category', 'tag_categories.id', :moderation_state)
      .group_by{|c| c[2]}
    tag_array = tags.each_with_object([]) do |(key, value), return_array|
      return_array << {
        category: key,
        category_id: value.first[3],
        tags: value.map{|tag| {
                          id: tag[0],
                          tag: tag[1],
                          moderation_state: Tag.moderation_text(tag[4]),
                        }
        }
      }
    end
    render json: tag_array
  end
end
