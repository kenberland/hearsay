require 'minitest'
require 'factory_girl'
require "#{Dir.pwd}/test/test_helper"

include Rails.application.routes.url_helpers
default_url_options[:host] = 'localhost:8080'

target = FactoryGirl.create(:phone_number_registration, :verified,
                            device_phone_number: '13105551212')
tagger = FactoryGirl.create(:phone_number_registration, :verified)
my_tag = random_tag
params = { currentUser: tagger.device_uuid, tag: { id: my_tag } }
headers = { 'API-VERSION' => 2 }
app.post(user_tags_url(target.device_phone_number), params, headers)
