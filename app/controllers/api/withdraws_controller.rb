# frozen_string_literal: true

class Api::WithdrawsController < ApplicationController
  before_action :authenticate_admin_or_arriver, only: [:create]

  def create
    @withdraw = Withdraw.new(create_params)
    return render json: { success: true, charge: 'withdraw can not added balance.' }, status: :unprocessable_entity if params[:amount].negative?

    if @withdraw.save
      log_audit(@withdraw, __method__)
      render json: { success: true, charge: @withdraw }, status: :ok
    else
      render json: { success: true, charge: @withdraw.errors }, status: :unprocessable_entity
    end
  end

  private

  def create_params
    params.require(:withdraw).permit(:amount)
  end

  def log_audit(model, operation)
    AuditLog.create(model: 'withdraw', model_id: model.id, operation: operation, operator: current_user.id)
  end
end
