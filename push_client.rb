class PushClient
  attr_accessor :gcm

  def send(ids,msg)
    ids.each do |id|
      method = typeof_id(id) == 'ios' ? :send_ios : :send_android
      self.send(method, id, msg)
    end
  end

  def send_android(ids, msg)
    msg ||= {
      data: {
        title: { "locKey": "app_name" },
        message: "You have been tagged!",
        image: "www/img/logo.png",
        icon: "bubbles",
        iconColor: "blue"

      },
    }
    gcm.send(ids, msg)
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
