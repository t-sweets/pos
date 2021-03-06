# frozen_string_literal: true

class Api::ChargesController < ApplicationController
  before_action :authenticate_admin_or_pos, only: [:create]

  def create
    @charge = Charge.new(create_params)
    return render json: { success: false, errors: 'charge can only be added.' }, status: :unprocessable_entity if params[:amount].negative?
    return render json: { success: false, errors: 'this payment method cant add money.' }, status: :unprocessable_entity unless PaymentMethod.find(params[:payment_method_id]).addable

    Charge.transaction do
      if @charge.save!
        log_audit(@charge, __method__)
        render json: { success: true, charge: @charge.attributes.except('created_at', 'updated_at') }, status: :ok
      else
        render json: { success: false, errors: @charge.errors }, status: :unprocessable_entity
      end
    end
  rescue StandardError => e
    render json: { success: false, errors: [e] }, status: :unprocessable_entity
  end

  private

  def create_params
    params.require(:charge).permit(:payment_method_id, :amount)
  end

  def log_audit(model, operation)
    AuditLog.create!(model: 'charge', model_id: model.id, operation: operation, operator: current_user.id)
  end
end
