# frozen_string_literal: true

class Api::RegistersController < ApplicationController
  before_action :set_register
  before_action :authenticate_admin_or_inventoryer, only: %i[show check]

  def show
    balance = @register.show
    render json: balance.to_json(only: %i[amount sales card_added]), status: :ok
  end

  def check
    return render json: { success: false, errors: 'cash_amount is required' }, status: :bad_request unless params[:cash_amount]

    balance = @register.check(params[:cash_amount], current_user)
    if balance
      binding.pry
      render json: { success: true, register_check: { register_cash_amount: params[:cash_amount], pos_register_cash_mount: balance.amount, deposit: Deposit.last.amount } }, status: :ok
    else
      render json: { success: false, errors: 'register could not check' }, status: :unprocessable_entity
    end
    # TODO: response which card charged If something card to charge other than T-pay will be
  end

  private

  def set_register
    @register = Register.first
    # TODO: レジは1つしかない想定
    # 2つ以上にしたくなったら、会計時にレジ情報を渡してもらうか、POS情報に入れる
  end
end
