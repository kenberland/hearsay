class V2::TagsController < ApplicationController

  def index
    tags = Tag.joins(:tag_category).pluck(:tag, '"tag_categories"."category"').group_by{|category| category.last}

    tag_array = tags.each_with_object([]) do |(key, value), return_array|
      return_array << {
        category: key,
        tags: value.flatten.reject{|tag_name| tag_name == key}
      }
    end

    render json: tag_array
  end
end
