class PushClient
  attr_accessor :gcm, :message

  def push(id, message)
    @message = message
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
        message: message,
        image: "www/img/logo.png",
        icon: "bubbles",
        iconColor: "blue"

      },
    }
    gcm.send([id], msg)
  end

  def send_ios(id)
    msg ||= {
      :alert => message,
      :badge => 1,
      :sound => 'default',
    }
    APNS.send_notification(id, msg)
  end

  def initialize
    @gcm ||= GCM.new(ENV['GCM_API_KEY'])
  end
end
