# frozen_string_literal: true

class Api::WithdrawsController < ApplicationController
  before_action :authenticate_admin_or_arriver, only: [:create]

  def create
    return render json: { success: false, errors: 'withdraw can not added balance.' }, status: :unprocessable_entity if params[:amount].negative?

    @withdraw = Withdraw.new(amount: params[:amount], register_id: Register.first.id)

    if @withdraw.save
      log_audit(@withdraw, __method__)
      binding.pry
      render json: { success: true, charge: @withdraw }, status: :ok
    else
      render json: { success: false, errors: @withdraw.errors }, status: :unprocessable_entity
    end
  end

  private

  def log_audit(model, operation)
    AuditLog.create(model: 'withdraw', model_id: model.id, operation: operation, operator: current_user.id)
  end
end
