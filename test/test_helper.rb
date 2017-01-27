ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'support/factory_girl'
class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  # fixtures :all

  # Add more helper methods to be used by all tests here...
end

def hearsay_xml_http_request(method, path, parameters)
  headers = { 'API-VERSION' => 2 }
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

def target_phone_number
  Faker::PhoneNumber.phone_number.gsub(/\D/,'')
end

def random_tag
  Tag.all[rand*Tag.count].id
end

