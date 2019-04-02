# frozen_string_literal: true

class Api::UsersController < ApplicationController
  before_action :authenticate_admin, only: [:index]
  before_action :authenticate_signed_in, only: [:update]
  before_action :set_user, only: %i[update destroy]

  def index
    @users = User.alive_all
    render json: @users, only: %i[id name email authority_id created_at]
  end

  def update
    return render json: { success: false, errors: ['permission denied!'] }, status: :unprocessable_entity if @user.id != current_user.id && !current_user.authority.admin?

    if @user.update(update_params)
      log_audit(@user, __method__)
      render json: { success: true, data: @user }, status: :ok
    else
      render json: { success: false, errors: [@user.errors] }, status: :unprocessable_entity
    end
  end

  def destroy
    if @user&.update(deleted: true)
      log_audit(@user, __method__)
      render json: { success: true, user: @user }, status: :no_content
    else
      render json: { success: false, errors: [@user.errors] }, status: :unprocessable_entity
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def update_params
    if current_user.authority.admin?
      params.permit(:name, :email, :password, :authority_id)
    else
      params.permit(:name, :email, :password)
    end
  end

  def log_audit(model, operation)
    AuditLog.create(model: 'user', model_id: model.id, operation: operation, operator: current_user.id)
  end
end
