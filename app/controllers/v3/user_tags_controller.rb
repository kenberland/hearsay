require 'pp'

class V3::UserTagsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
    select_sql = <<EOD
to_user_uid, LEFT(tags.tag,24) as tagname,
tags.id as tag_id, tag_categories.category,
(to_user_uid = '#{from_phone}'
|| from_user_uid ='#{from_device_uuid}') as `can_delete`,
tags.moderation_state,
tags.phone_number_registration_id = #{registration.id} as is_tag_creator
EOD
    r = UserTag.where(to_user_uid: user_lut.keys)
      .joins(tag: :tag_category)
      .select(select_sql)
      .collect{|r| { to_user_uid: r.to_user_uid, tag_id: r.tag_id,
                     name: r.tagname, category: r.category,
                     is_current_user: r.can_delete == 1,
                     moderation_state: Tag::moderation_text(r.moderation_state),
                     is_tag_creator: r.is_tag_creator == 0 ? false : true
               } }
    r = r.each_with_object({}) do |v, h|
      target = user_lut[v[:to_user_uid]]
      unless h.has_key?(target)
        h[target] = { tags: {} }
      end
      tag_hash = h[target][:tags]

      tag_id = v[:tag_id].to_i
      if tag_hash.has_key?(tag_id)
        tag_hash[tag_id][:count] += 1
      else
        v[:count] = 1
        v.delete(:to_user_uid)
        v.delete(:tag_id)
        tag_hash[tag_id] = v
      end
    end
    r = template_hash.merge(r)
    r = r.deep_merge(empty_registered_hash)
    r = r.deep_merge(registered_phones)
    render json: r
  end

  private

  def users
    params['tagsForUsers']
  end

  def template_hash
    Hash[users.zip].each_with_object({}) do |(k,v), o|
      o[k] = {tags: [] }
    end
  end

  def user_lut
    @memo_user_lut ||= Hash[users.zip]
      .each_with_object({}) do |(k,v),o|
      o[Phony.normalize(k, cc: '1')] = k
    end
  end

  def registration
    PhoneNumberRegistration.order('created_at desc').find_by(device_uuid: params[:currentUser])
  end

  def from_phone
    registration.try(:device_phone_number)
  end

  def from_device_uuid
    registration.try(:device_uuid)
  end

  def empty_registered_hash
    return @memo_empty_registered_hash if @memo_empty_registered_hash
    h = {}
    user_lut.values.each do |k|
      h[k] = { registered: false }
    end
    @memo_empty_registered_hash = h
  end

  def registered_phones
    PhoneNumberRegistration
      .select(:device_phone_number, :verification_state)
      .where(device_phone_number: user_lut.keys)
      .each_with_object({}) do |e, o|
      thing = { registered: e.verification_state == 'verified' }
      o[user_lut[e.device_phone_number]] = thing
    end
  end
end
