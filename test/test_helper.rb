ENV["RAILS_ENV"] ||= "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  ActiveRecord::Migration.check_pending!

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  fixtures :all

  # Add more helper methods to be used by all tests here...
  class ActionController::TestCase
    def response_json
      ActiveSupport::JSON.decode @response.body
    end
  end
end

def validate_response_body(messages, response_body)
  assert_equal messages.size, response_body.size
  messages.each {|m|
    assert response_body.detect{|j| j['id'] == m['id'] }
  }
end
