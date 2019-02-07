# frozen_string_literal: true

class Api::PaymentMethodsController < ApplicationController
  before_action :authenticate_admin_or_pos

  def index
    expires_now
    @payment_methods = PaymentMethod.all
    render json: @payment_methods
  end
end
