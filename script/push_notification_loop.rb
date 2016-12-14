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
    tag_push_manager = TagPushManager.new(push_client)
    if tag_push_manager.has_user_tag?
      puts "attempting to notify about UserTag #{tag_push_manager.user_tag.id} #{tag_push_manager.user_tag.notification_state}"
      tag_push_manager.notify
    else
      puts "no new UserTags"
    end
  end
end

push_notification_loop = PushNotificationLoop.new
push_notification_loop.run!
