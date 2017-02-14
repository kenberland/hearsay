ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require File.expand_path('test/support/factory_girl')
class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  # fixtures :all

  # Add more helper methods to be used by all tests here...
end

def hearsay_xml_http_request(method, path, parameters, version='2')
  headers = { 'API-VERSION' => version }
  xml_http_request(method, path, parameters,
                   headers_or_env = headers
                  )
end

# Mess, courtesy of https://github.com/floere/phony/issues/266
def normalized_fake_number
  phone = nil
  normal = nil
  loop do
    phone = Faker::PhoneNumber.phone_number
    normal = Phony.normalize(phone, cc: '1')[0..10]
    break if Phony.plausible?(normal)
  end
  normal
end

def chitchatize_number number
  number.gsub(/\D+/, '')
end

def create_tag_mock_post tag, from, to
  UserTag.create tag_id: tag.id,
                 from_user_uid: from.device_uuid,
                 to_user_uid: to.device_phone_number
end

def target_phone_number
  Faker::PhoneNumber.phone_number.gsub(/\D/,'')
end

def random_tag
  Tag.all[rand*Tag.count].id
end

def random_tag_category
  TagCategory.all[rand*TagCategory.count].category
end

def random_tag_category_obj
  TagCategory.all[rand*TagCategory.count]
end
