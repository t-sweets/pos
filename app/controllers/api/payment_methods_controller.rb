# frozen_string_literal: true

class Api::PaymentMethodsController < ApplicationController
  def index
    expires_now
    @payment_methods = PaymentMethod.all
    render json: @payment_methods
  end
end
