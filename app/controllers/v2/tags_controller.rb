class V2::TagsController < ApplicationController

  def index
    tags = Tag.joins(:tag_category).pluck(:tag, '"tag_categories"."category"').group_by{|category| category.last}

    tag_array = tags.each_with_object([]) do |(key, value), return_array|
      return_array << {
        category: key,
        tags: value.flatten
      }
    end

    render json: tag_array
  end

  def show
    UserTag.where(to_user_uid: '103048943427138').group([:to_user_uid, :tag_id]).order('count_tag_id desc').count(:tag_id)

    tags = Tag.joins(:tag_category).pluck(:tag, '"tag_categories"."category"').group_by{|category| category.last}

    tag_array = tags.each_with_object([]) do |(key, value), return_array|
      return_array << {
        category: key,
        tags: value.flatten
      }
    end

    render json: tag_array
  end
end
