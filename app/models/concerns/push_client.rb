class PushClient
  attr_accessor :gcm

  def push(id)
    self.send(method(id), id)
  end

  private

  def method(id)
    :send_android
  end

  def send_android(id)
    msg ||= {
      data: {
        title: { "locKey": "app_name" },
        message: "You have been tagged!",
        image: "www/img/logo.png",
        icon: "bubbles",
        iconColor: "blue"

      },
    }
    gcm.send([id], msg)
  end

  def send_ios(ids, msg)
    msg ||= {
      :alert => "You've been tagged!",
      :badge => 1,
      :sound => 'default',
    }
    APNS.send_notification(ids, msg)
  end

  def initialize
    @gcm ||= GCM.new(ENV['GCM_API_KEY'])
  end
end
