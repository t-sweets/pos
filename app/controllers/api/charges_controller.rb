# frozen_string_literal: true

class Api::ChargesController < ApplicationController
  before_action :authenticate_admin_or_pos, only: [:create]

  def create
    @charge = Charge.new(create_params)
    if params[:amount].negative?
      render json: { success: true, charge: 'charge can only be added.' }, status: :unprocessable_entity
    elsif @charge.save
      log_audit(@charge, __method__)
      render json: { success: true, charge: @charge }, status: :ok
    else
      render json: { success: true, charge: @charge.errors }, status: :unprocessable_entity
    end
  end

  private

  def create_params
    params.require(:charge).permit(:payment_method_id, :amount)
  end

  def log_audit(model, operation)
    AuditLog.create(model: 'charge', model_id: model.id, operation: operation, operator: current_user.id)
  end
end
