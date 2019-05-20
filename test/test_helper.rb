# frozen_string_literal: true

ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...

  def login(user)
    post 'http://localhost:3000/api/v1/auth/sign_in', params: { email: user[:email], password: 'password' }, as: :json
    response.headers.slice('client', 'access-token', 'uid')
  end
end
