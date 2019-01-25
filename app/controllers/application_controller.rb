# frozen_string_literal: true

class ApplicationController < ActionController::API
  before_action :authenticate_admin!, except: %i[new create]
  include DeviseTokenAuth::Concerns::SetUserByToken
end
