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

  def show
    uuid = '103048943427138'
    tags = get_tags uuid
    tag_counts = count uuid
    tag_categories = TagCategory.all.pluck(:id, :category).to_h

    user_cloud = tag_counts.each_with_object([]) do |(key, value), return_array|
      tag = current_tag(tags, key)
      return_array << {
        category: tag_category(tag_categories, tag),
        tags: {tag.tag => value}
      }
    end
    render json: user_cloud
  end

  private

  def current_tag(user_tags, current_tag_info)
    user_tags.select{|tag| tag.id == current_tag_info.last}.first
  end

  def tag_category(all_tag_categories, tag)
    all_tag_categories[tag.tag_category_id]
  end

  def count(user_id)
    UserTag.where(to_user_uid: user_id).group([:to_user_uid, :tag_id]).order('count_tag_id desc').count(:tag_id)
  end

  def get_tags uid
    User.find_by_uid(uid).tags.uniq rescue []
  end
end
