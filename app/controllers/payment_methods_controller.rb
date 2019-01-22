class PaymentMethodsController < ApplicationController
  def index
    @payment_methods = PaymentMethod.all
    render json: @payment_methods
  end
end
