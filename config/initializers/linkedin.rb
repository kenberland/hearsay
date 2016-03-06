LinkedIn.configure do |config|
  config.token = ENV['LI_CLIENT_ID']
  config.secret = ENV['LI_CLIENT_SECRET']
end
