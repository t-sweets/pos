# frozen_string_literal: true

class Register < ApplicationRecord
  validates :name, presence: true
  validates :initial_cash_amount, presence: true

  def show
    new_balance
  end

  def init(cash_amount)
    update(initial_cash_amount: cash_amount)
  end

  def check(amount)
    balance = new_balance
    check = RegiCheck.new(user_id: current_user.id, register_cash_amount: amount, pos_register_cash_amount: balance.amount)
    balance if check.save
  end

  private

  def new_balance
    sales = Purchase.all.map(&:sales).sum
    card_added = Charge.all.map(&:amount).sum
    withdraws = Withdraw.all.map(&:amount).sum
    returns = Return.all.map { |r| r.purchase.sales }.sum

    amount = initial_cash_amount + sales + card_added - withdraws - returns

    Balance.new(amount: amount, sales: sales, card_added: card_added)
  end
end
