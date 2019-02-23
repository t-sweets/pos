# frozen_string_literal: true

class Api::UsersController < ApplicationController
  before_action :authenticate_admin, only: [:index]
  before_action :set_user, only: [:destroy]

  def index
    @users = User.alive_all
    render json: @users, only: %i[id name email authority_id created_at]
  end

  def destroy
    if @user&.update(deleted: true)
      log_audit(user, __method__)
      render json: { success: true, user: @user }, status: :ok
    else
      render json: { success: false, errors: [@user.errors] }, status: :unprocessable_entity
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def log_audit(model, operation)
    AuditLog.create(model: 'user', model_id: model.id, operation: operation, operator: current_user.id)
  end
end
