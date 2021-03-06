# frozen_string_literal: true

class Api::DepositsController < ApplicationController
  before_action :authenticate_admin_or_inventoryer_or_arriver, only: [:create]

  def create
    return render json: { success: true, charge: 'deposit can not subtract balance.' }, status: :unprocessable_entity if params[:amount].negative?

    @deposit = Deposit.new(amount: params[:amount], register_id: Register.first.id)

    Deposit.transaction do
      if @deposit.save!
        log_audit(@deposit, __method__, params[:detail])
        render json: { success: true, charge: @deposit.attributes.except('created_at', 'updated_at') }, status: :ok
      else
        render json: { success: true, errors: @deposit.errors }, status: :unprocessable_entity
      end
    end
  rescue StandardError => e
    render json: { success: false, errors: [e] }, status: :unprocessable_entity
  end

  private

  def log_audit(model, operation, detail)
    AuditLog.create!(model: 'deposit', model_id: model.id, operation: operation, operator: current_user.id, detail: detail)
  end
end
