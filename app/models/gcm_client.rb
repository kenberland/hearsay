require 'gcm'

class GcmClient
  attr_accessor :gcm

  def send(ids, msg)
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

  def initialize
    @gcm ||= GCM.new(ENV['GCM_API_KEY'])
  end
end
