# frozen_string_literal: true

class Api::DepositsController < ApplicationController
  before_action :authenticate_admin_or_arriver, only: [:create]

  def create
    return render json: { success: true, charge: 'deposit can not subtract balance.' }, status: :unprocessable_entity if params[:amount].negative?

    @deposit = Deposit.new(amount: params[:amount], register_id: Register.first.id)

    if @deposit.save
      log_audit(@deposit, __method__)
      render json: { success: true, charge: @deposit }, status: :ok
    else
      render json: { success: true, errors: @deposit.errors }, status: :unprocessable_entity
    end
  end

  private

  def log_audit(model, operation)
    AuditLog.create(model: 'deposit', model_id: model.id, operation: operation, operator: current_user.id)
  end
end
