class PushClient
  attr_accessor :gcm, :push_message

  def push(id, push_message)
    @push_message = push_message
    self.send(method(id), id)
  end

  private

  def method(id)
    id.size == 64 ? :send_ios : :send_android
  end

  def send_android(id)
    msg ||= {
      data: {
        title: { "locKey": "app_name" },
        message: push_message.message,
        data: push_message.to_h,
        image: "www/img/logo.png",
        icon: "bubbles",
        iconColor: "blue"

      },
    }
    gcm.send([id], msg)
  end

  def send_ios(id)
    msg ||= {
      :alert => push_message.message,
      :tag => push_message.tag,
      :badge => 1,
      :sound => 'default',
    }
    APNS.send_notification(id, msg)
  end

  def initialize
    @gcm ||= GCM.new(ENV['GCM_API_KEY'])
  end
end
