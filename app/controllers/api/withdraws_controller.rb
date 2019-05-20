# frozen_string_literal: true

class Api::WithdrawsController < ApplicationController
  before_action :authenticate_admin_or_arriver, only: [:create]

  def create
    return render json: { success: false, errors: 'withdraw can not added balance.' }, status: :unprocessable_entity if params[:amount].negative?

    @withdraw = Withdraw.new(amount: params[:amount], register_id: Register.first.id)

    Withdraw.transaction do
      if @withdraw.save!
        log_audit(@withdraw, __method__, params[:detail])
        render json: { success: true, charge: @withdraw.attributes.except('created_at', 'updated_at') }, status: :ok
      else
        render json: { success: false, errors: @withdraw.errors }, status: :unprocessable_entity
      end
    end
  rescue StandardError => e
    render json: { success: false, errors: [e] }, status: :unprocessable_entity
  end

  private

  def log_audit(model, operation, detail)
    AuditLog.create(model: 'withdraw', model_id: model.id, operation: operation, operator: current_user.id, detail: detail)
  end
end
