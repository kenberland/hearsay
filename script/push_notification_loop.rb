class PushNotificationLoop
  attr_accessor :push_client

  def initialize
    @push_client = PushClient.new
  end

  def run!
    loop do
      run
      sleep 5
    end
  end

  private

  def run
    user_tag = nil
    UserTag.transaction do
      user_tag = UserTag.lock.limit(1).where(notification_state: nil).first
      if user_tag
        user_tag.notification_state = :in_progress
        user_tag.save!
      end
    end

    if user_tag
      puts "attempting to notify about UserTag #{user_tag.id} #{user_tag.notification_state}"
      phone_number = user_tag.to_user_uid
      device_uuid = PhoneNumberRegistration.find_by_device_phone_number(phone_number).try(:device_uuid)
      if device_uuid
        registration_id = Registration.find_by_device_uuid(device_uuid).try(:registration_id)
        if registration_id
          puts "notify id: #{registration_id} for user at phone #{phone_number}"
        else
          puts "no push registration_id for device uuid: #{device_uuid}"
        end
      else
        puts "no device registered for phone #{phone_number}"
      end
      push_client.push(registration_id)
      user_tag.notification_state = :notified
      user_tag.save!
      puts "finished attempting to notify about UserTag #{user_tag.id} #{user_tag.notification_state}"
    else
      puts "no new UserTags"
    end
  end
end

push_notification_loop = PushNotificationLoop.new
push_notification_loop.run!
