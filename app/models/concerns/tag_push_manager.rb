class TagPushManager

  IN_PROGRESS = 1
  NOTIFIED = 2
  UNNOTIFIABLE = 3

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
      mark_as_in_progress if user_tag
    end
  end

  def mark_as_in_progress
    user_tag.update_attribute(:notification_state, IN_PROGRESS)
    @push_message_type = get_push_message_type
  end

  def has_user_tag?
    !user_tag.nil?
  end

  def notify
    push_message = PushMessage.new
      .with_message(message_for_hearsay_action)
      .with_tag(tag.tag)
      .with_tag_category(tag.tag_category.category)
      .with_seek_to_phone(to_user_uid)
    if recipient_push_id
      push_client.push(recipient_push_id, push_message)
      user_tag.notification_state = NOTIFIED
    else
      user_tag.notification_state = UNNOTIFIABLE
    end
    user_tag.save!
  end

  private

  def message_for_hearsay_action
    case @push_message_type
    when TAGGED
      I18n.t('tag-messages.tagged')
    when REMOVED
      I18n.t('tag-messages.removed')
    when UNTAGGED
      I18n.t('tag-messages.untagged')
    end
  end

  def get_push_message_type
    if action == 'create' or action == 'update'
      TAGGED
    elsif action == 'destroy' and actor_uuid == to_user_uuid
      REMOVED
    else
      UNTAGGED
    end
  end


  def recipient_push_id
    case @push_message_type
    when TAGGED
      push_id_for_uuid(to_user_uuid)
    when REMOVED
      push_id_for_uuid(from_user_uid)
    when UNTAGGED
      push_id_for_uuid(to_user_uuid)
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

  def to_user_uuid
    uuid_for_phone(to_user_uid)
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

  def to_user_uid
    UserTag.unscoped.find(user_tag.auditable_id).to_user_uid
  end

  def from_user_uid
    UserTag.unscoped.find(user_tag.auditable_id).from_user_uid
  end

  def tag
    UserTag.unscoped.find(user_tag.auditable_id).tag
  end
end
