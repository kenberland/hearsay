class TagPushManager
  include Singleton
  def reserve
    user_tag = nil
    UserTag.transaction do
      user_tag = UserTag.unscoped.lock.limit(1).where(notification_state: nil).first
      user_tag.update_attribute(:notification_state, :in_progress) if user_tag
    end
    user_tag.nil? ? false : user_tag
  end
end
