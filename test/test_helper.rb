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
