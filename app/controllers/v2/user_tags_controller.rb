class V2::UserTagsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
    user_number = PhonyRails.normalize_number(params[:user_id])

    return render status: 404, text: 'User Not Found' unless User.find_by_phone_number(user_number)

    tags = get_tags user_number
    tag_counts = count user_number
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

  def create
    current_user = params[:currentUser]
    new_tag = Tag.find params[:tag][:id]
    user_number = PhonyRails.normalize_number(params[:user_id])
    new_user_tag = User.find_by(uid: user_number).user_tags.build tag_id: new_tag.id, from_user_uid: current_user.uid
    begin
      new_user_tag.save
    rescue PG::UniqueViolation => e
      Rails.logger.error e
    end
    redirect_to tag_cloud_connection_path(params[:users][:index]), status: 303
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
