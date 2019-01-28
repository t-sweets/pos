# frozen_string_literal: true

class ApplicationController < ActionController::API
  before_action :authenticate_user!, except: %i[new create]
  include DeviseTokenAuth::Concerns::SetUserByToken
  include ActionController::MimeResponds
end
