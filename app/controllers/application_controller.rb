# frozen_string_literal: true

class ApplicationController < ActionController::API
  before_action :authenticate_user!, except: %i[new create]
  include DeviseTokenAuth::Concerns::SetUserByToken
  include ActionController::MimeResponds

  def authenticate_admin
    return if user_signed_in? && current_user.admin?

    render json: {
      success: false,
      errors: ['purmission denied.']
    }, status: 401
  end
end
