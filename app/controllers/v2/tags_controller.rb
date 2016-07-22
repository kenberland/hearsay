class V2::TagsController < ApplicationController

  def index
    tags = Tag.joins(:tag_category).pluck(:tag, :id, '"tag_categories"."category"').group_by{|category| category.last}

    tag_array = tags.each_with_object([]) do |(key, value), return_array|
      return_array << {
        category: key,
        tags: value.map{|tag| { tag[1] => tag[0] } }
      }
    end

    render json: tag_array
  end
end
