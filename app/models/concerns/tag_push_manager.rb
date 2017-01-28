class TagPushManager

  IN_PROGRESS = 1
  NOTIFIED = 2

  TAGGED = 0
  UNTAGGED = 1
  REMOVED = 2

  attr_accessor :user_tag,
  :push_client,
  :tagger_uuid,
  :tagger_phone,
  :tagee_phone,
  :tagee_uuid

  def initialize(push_client)
    @user_tag = nil
    @push_client = push_client
    reserve
  end

  def reserve
    Audited::Audit.transaction do
      @user_tag = Audited::Audit.lock.limit(1).where(notification_state: nil).first
      user_tag.update_attribute(:notification_state, IN_PROGRESS) if user_tag
    end
  end

  def has_user_tag?
    !user_tag.nil?
  end

  def notify
    push_client.push(recipient_push_id, message_for_hearsay_action)
    user_tag.notification_state = NOTIFIED
    user_tag.save!
  end

  private

  def message_for_hearsay_action
    case @message
    when TAGGED
      I18n.t('tag-messages.tagged')
    when REMOVED
      I18n.t('tag-messages.removed')
    when UNTAGGED
      I18n.t('tag-messages.untagged')
    end
  end

  def recipient_push_id
    if action == 'create'
      @message = TAGGED
      push_id_for_uuid(uuid_for_phone(to_user_uid))
    elsif action == 'destroy' and actor_uuid == uuid_for_phone(to_user_uid)
      @message = REMOVED
      push_id_for_uuid(from_user_uid)
    else
      @message = UNTAGGED
      push_id_for_uuid(uuid_for_phone(to_user_uid))
    end
  end

  def uuid_for_phone phone
    PhoneNumberRegistration.order('created_at desc')
      .find_by_device_phone_number(phone)
      .try(:device_uuid)
  end

  def push_id_for_uuid uuid
    Registration.order('created_at desc')
      .find_by_device_uuid(uuid)
      .try(:registration_id)
  end

  def log_error message
    Rails.logger.error("ERROR: #{message}".red)
  end

  def log_info message
    Rails.logger.error(message.green)
  end

  def actor_uuid
    user_tag.username
  end

  def action
    user_tag.action
  end

  def audited_changes
    user_tag.audited_changes
  end

  def to_user_uid
    audited_changes['to_user_uid']
  end

  def from_user_uid
    audited_changes['from_user_uid']
  end
end
