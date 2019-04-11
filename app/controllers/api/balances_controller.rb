# frozen_string_literal: true

class Api::BalancesController < ApplicationController
  before_action :authenticate_admin_or_inventoryer, only: %i[show check]

  def show
    @balance = Balance.show
    render json: @balance.to_json(only: %i[amount sales card_added]), status: :ok
  end

  def check
    @balance = Balance.check
    if @balance
      render json: @balance
    else
      render json: { success: false, errors: 'something wrong' }, status: :unprocessable_entity
    end
    # TODO: response which card charged If something card to charge other than T-pay will be
  end
end
