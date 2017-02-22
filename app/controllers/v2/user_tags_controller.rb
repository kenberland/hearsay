class V2::UserTagsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
    render_index
  end

  def registration
    PhoneNumberRegistration.order('created_at desc').find_by(device_uuid: params[:currentUser])
  end

  def verified?
    registration.try(:verification_state) == "verified"
  end

  def from_phone
    registration.try(:device_phone_number)
  end

  def create
    unless verified?
      return render(text: I18n.t('errors.unverified'), status: 400)
    end

    if from_phone == Phony.normalize(params[:user_id], cc: '1')
      return render(text: I18n.t('errors.self-tagging'), status: 400)
    end

    to_user_uuid = Phony.normalize(params[:user_id], cc: '1')
    from_user_uuid = params[:currentUser]

    if params[:tag][:id]
      new_tag = Tag.find params[:tag][:id]
    else
      new_tag = create_new_tag(params[:tag][:newTag], params[:tag][:category])
    end

    unless new_tag.errors.empty?
      return render(text: new_tag.errors.full_messages.join(''), status: 400)
    end

    new_user_tag = UserTag.new({
                                 from_user_uid: from_user_uuid,
                                 to_user_uid: to_user_uuid,
                                 tag_id: new_tag.id
                               })

    attributes = new_user_tag.attributes
    attributes = attributes.except(*%w(created_at updated_at deleted_at id))
    deleted_records = UserTag.unscoped.where(attributes)

    if (deleted_records.count > 0)
      deleted_records.first.update_attributes(deleted_at: nil)
    else
      begin
        new_user_tag.save
      rescue ActiveRecord::RecordNotUnique => e
        Rails.logger.error e
      end
    end
    render_index(params[:tag][:newTag] ? new_tag : nil)
  end

  def destroy
    from_user_uuid = params[:currentUser]
    to_user_uuid = Phony.normalize(params[:user_id], cc: '1')

    unless verified?
      return render(text: I18n.t('errors.unverified-delete'), status: 400)
    end

    if params[:id] != 'null'
      tag_id = params[:id]
    else
      tag_id = create_new_tag(params[:tag][:name], params[:tag][:category])
    end

    if from_phone == to_user_uuid
      user_tag = UserTag.where({
                                 tag_id: tag_id,
                                 to_user_uid: to_user_uuid
                               })
    else
      user_tag = UserTag.where({
                                 tag_id: tag_id,
                                 from_user_uid: from_user_uuid,
                                 to_user_uid: to_user_uuid
                               })
    end
    user_tag.destroy_all
    render_index
  end

  private

  def render_index(new_tag = nil)
    user_number = Phony.normalize(params[:user_id], cc: '1')

    tag_counts = count user_number
    tag_categories = TagCategory.all.pluck(:id, :category).to_h
    tags_hash = tag_counts.keys.each_with_object({}) do |tag, return_hash|
      current_tag = return_hash[tag.last]
      count = current_tag.nil? ? 1 : current_tag[:count] += 1
      is_current_user = (tag[1] == current_user ||
                         tag[0] == current_phone ||
                         current_tag.try(:[], :is_current_user))

      return_hash[tag.last] = {count: count, is_current_user: is_current_user}
    end

    user_cloud = tags_hash.each_with_object([]) do |(key, value), return_array|
      is_current_user = !!value[:is_current_user]
      tag = current_tag(key)
      return_array << {
        category: tag_category(tag_categories, tag),
        count: value[:count],
        name: tag.tag,
        is_current_user: is_current_user,
        tagId: key
      }
    end
    render json: { tags: user_cloud,
                   new_tag: new_tag,
                   registered: is_registered(user_number)
                 }
  end

  def is_registered(user_number)
    PhoneNumberRegistration
      .select(:verification_state)
      .where(device_phone_number: user_number)
      .first
      .try(:verification_state) == 'verified'
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

  def create_new_tag(name, category)
    tc = TagCategory.find_by_category category
    Tag.find_or_create_by({ tag: name, tag_category: tc }) rescue ActiveRecord::RecordNotUnique
  end
end
