class V2::UserTagsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
    render_index
  end

  def create
    from_user_uuid = params[:currentUser]
    to_user_uuid = PhonyRails.normalize_number(params[:user_id])
    new_tag = Tag.find params[:tag][:id]

    new_user_tag = UserTag.new({
      from_user_uid: from_user_uuid,
      to_user_uid: to_user_uuid,
      tag_id: new_tag.id
    })

    begin
      new_user_tag.save
    rescue PG::UniqueViolation => e
      Rails.logger.error e
    end

    render_index
  end

  def destroy
    from_user_uuid = params[:currentUser]
    to_user_uuid = PhonyRails.normalize_number(params[:user_id])
    tag_id = params[:id]

    user_tag = UserTag.where({
      tag_id: tag_id,
      from_user_uid: from_user_uuid,
      to_user_uid: to_user_uuid
    })
    user_tag.destroy_all
    render_index
  end

  private

  def render_index
    user_number = PhonyRails.normalize_number(params[:user_id])
    current_user = params[:currentUser]

    tag_counts = count user_number
    tag_categories = TagCategory.all.pluck(:id, :category).to_h

    tags_hash = tag_counts.keys.each_with_object({}) do |tag, return_hash|
      current_tag = return_hash[tag.last]
      count = current_tag.nil? ? 1 : current_tag[:count] += 1
      is_current_user = (tag[1] == current_user || current_tag.try(:[], :is_current_user))

      return_hash[tag.last] = {count: count, is_current_user: is_current_user}
    end

    user_cloud = tags_hash.each_with_object([]) do |(key, value), return_array|
      is_current_user = value[:is_current_user] == nil ? false : true
      tag = current_tag(key)
      return_array << {
        category: tag_category(tag_categories, tag),
        count: value[:count],
        name: tag.tag,
        is_current_user: is_current_user,
        tagId: key
      }
    end
    render json: user_cloud
  end

  def current_tag(current_tag_info)
    Tag.select{|tag| tag.id == current_tag_info}.first
  end

  def tag_category(all_tag_categories, tag)
    all_tag_categories[tag.tag_category_id]
  end

  def count(user_id)
    UserTag.where(to_user_uid: user_id).group([:to_user_uid, :from_user_uid, :tag_id]).order('count_tag_id desc').count(:tag_id)
  end
end
