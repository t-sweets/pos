# frozen_string_literal: true

class Api::BalancesController < ApplicationController
  before_action :authenticate_admin_or_inventoryer, only: [:check]

  def check
    @balance = Balance.check
    render json: @balance
    # TODO: response which card charged If something card to charge other than T-pay will be
  end
end
