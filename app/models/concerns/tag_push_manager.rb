class TagPushManager

  attr_accessor :user_tag, :push_client, :device_uuid, :registration_id

  def initialize(push_client)
    @user_tag = nil
    @push_client = push_client
    reserve
  end

  def reserve
    UserTag.transaction do
      @user_tag = UserTag.unscoped.lock.limit(1).where(notification_state: nil).first
      user_tag.update_attribute(:notification_state, :in_progress) if user_tag
    end
  end

  def has_user_tag?
    !user_tag.nil?
  end

  def notify
    if device_uuid && registration_id
      Rails.logger.info("notify id: #{registration_id} for user at phone #{phone_number}".green)
      push_client.push(registration_id)
      user_tag.notification_state = :notified
      user_tag.save!
    else
      Rails.logger.error "ERROR: device_uuid: #{device_uuid}".red
      Rails.logger.error "ERORR: registration_id: #{registration_id}".red
    end
  end

  private

  def phone_number
    user_tag.to_user_uid
  end

  def device_uuid
    @device_uuid ||= PhoneNumberRegistration.order('created_at desc')
                   .find_by_device_phone_number(phone_number)
                   .try(:device_uuid)
  end

  def registration_id
    @registration_id ||= Registration.order('created_at desc')
                       .find_by_device_uuid(device_uuid)
                       .try(:registration_id)
  end
end
