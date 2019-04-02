# frozen_string_literal: true

class ApplicationController < ActionController::API
  before_action :authenticate_user!, except: %i[new create]
  include DeviseTokenAuth::Concerns::SetUserByToken
  include ActionController::MimeResponds

  def authenticate_admin_and_login_user
    return if user_signed_in? && (current_user.authority.admin? || current_user.email == params[:email])

    response_forbidden
  end

  def authenticate_signed_in
    return if user_signed_in?

    response_forbidden
  end

  def authenticate_admin_or_pos
    return if user_signed_in? && (current_user.authority.admin? || current_user.authority.pos?)

    response_forbidden
  end

  def authenticate_admin_or_inventoryer
    return if user_signed_in? && (current_user.authority.admin? || current_user.authority.inventoryer?)

    response_forbidden
  end

  def authenticate_admin_or_arriver
    return if user_signed_in? && (current_user.authority.admin? || current_user.authority.arriver?)

    response_forbidden
  end

  def authenticate_admin_or_pos_or_arriver
    return if user_signed_in? && (current_user.authority.admin? || current_user.authority.pos? || current_user.authority.arriver?)

    response_forbidden
  end

  def authenticate_admin
    return if user_signed_in? && current_user.authority.admin?

    response_forbidden
  end

  def authenticate_pos
    return if user_signed_in? && current_user.authority.pos?

    response_forbidden
  end

  private

  def response_forbidden
    render json: {
      success: false,
      errors: ['permission denied.']
    }, status: :forbidden
  end
end
