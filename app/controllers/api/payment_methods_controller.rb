class Api::PaymentMethodsController < ApplicationController
  before_action :authenticate_admin!
  
  def index
    @payment_methods = PaymentMethod.all
    render json: @payment_methods
  end
end
