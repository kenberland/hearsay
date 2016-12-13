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
    if user_tag = TagPushManager.instance.reserve
      puts "attempting to notify about UserTag #{user_tag.id} #{user_tag.notification_state}"
      phone_number = user_tag.to_user_uid
      device_uuid = PhoneNumberRegistration.order('created_at desc').find_by_device_phone_number(phone_number).try(:device_uuid)
      if device_uuid
        registration_id = Registration.order('created_at desc').find_by_device_uuid(device_uuid).try(:registration_id)
        if registration_id
          puts "notify id: #{registration_id} for user at phone #{phone_number}"
          push_client.push(registration_id)
          user_tag.notification_state = :notified
          user_tag.save!
        else
          puts "no push registration_id for device uuid: #{device_uuid}"
        end
      else
        puts "no device registered for phone #{phone_number}"
      end
      puts "finished attempting to notify about UserTag #{user_tag.id} #{user_tag.notification_state}"
    else
      puts "no new UserTags"
    end
  end
end

push_notification_loop = PushNotificationLoop.new
push_notification_loop.run!
