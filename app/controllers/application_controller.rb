# frozen_string_literal: true

class ApplicationController < ActionController::API
  before_action :authenticate_user!, except: %i[new create]
  include DeviseTokenAuth::Concerns::SetUserByToken
  include ActionController::MimeResponds

  def authenticate_admin_and_login_user
    return if user_signed_in? && (current_user.authority.admin? || current_user.email == params[:email])

    render json: {
      success: false,
      errors: ['permission denied.']
    }, status: 401
  end

  def authenticate_admin_or_pos
    return if user_signed_in? && (current_user.authority.admin? || current_user.authority.pos?)

    render json: {
      success: false,
      errors: ['permission denied.']
    }, status: 401
  end

  def authenticate_admin_or_inventoryer
    return if user_signed_in? && (current_user.authority.admin? || current_user.authority.inventoryer?)

    render json: {
      success: false,
      errors: ['permission denied.']
    }, status: 401
  end

  def authenticate_admin_or_arriver
    return if user_signed_in? && (current_user.authority.admin? || current_user.authority.arriver?)

    render json: {
      success: false,
      errors: ['permission denied.']
    }, status: 401
  end

  def authenticate_admin
    return if user_signed_in? && current_user.authority.admin?

    render json: {
      success: false,
      errors: ['permission denied.']
    }, status: 401
  end

  def authenticate_pos
    return if user_signed_in? && current_user.authority.pos?

    render json: {
      success: false,
      errors: ['permission denied.']
    }, status: 401
  end
end
