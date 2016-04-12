Rails.application.config.middleware.use OmniAuth::Builder do
  provider :developer unless Rails.env.production?
  provider :linkedin, ENV['LI_CLIENT_ID'], ENV['LI_CLIENT_SECRET'], :scope => 'r_basicprofile r_emailaddress' # r_network
  provider :facebook, ENV['FACEBOOK_KEY'], ENV['FACEBOOK_SECRET'], :scope => 'user_relationships,user_location'
end
