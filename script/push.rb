require 'houston'

# Environment variables are automatically read, or can be overridden by any specified options. You can also
# conveniently use `Houston::Client.development` or `Houston::Client.production`.
APN = Houston::Client.development
puts APN.gateway_uri
APN.certificate = File.read("/Users/bird/Desktop/ck.pem")

# An example of the token sent back when a device registers for notifications
token = "906634ec11eb2fd4644abd394a396ea658b0a6d72622a370aaad26a1607d1489"

# Create a notification that alerts a message to the user, plays a sound, and sets the badge on the app
notification = Houston::Notification.new(device: token)
notification.alert = "from bird"

# Notifications can also change the badge count, have a custom sound, have a category identifier, indicate available Newsstand content, or pass along arbitrary data.
notification.badge = 57
notification.sound = "sosumi.aiff"
#notification.category = "INVITE_CATEGORY"
#notification.content_available = true
#notification.custom_data = {foo: "bar"}

# And... sent! That's all it takes.
APN.push(notification)
