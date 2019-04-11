# frozen_string_literal: true

class Register < ApplicationRecord
  validates :name, presence: true
  validates :initial_cash_amount, presence: true

  def show
    new_balance
  end

  def check(amount, user)
    balance = new_balance
    check = RegiCheck.new(user_id: user.id, register_cash_amount: amount, pos_register_cash_amount: balance.amount, register_id: id)
    update(initial_cash_amount: initial_cash_amount + (amount - balance.amount))
    balance if check.save
  end

  private

  def new_balance
    last_check = RegiCheck.last

    sales = last_check ? Purchase.where('created_at BETWEEN ? AND ?', last_check.created_at, Time.now).map(&:sales).sum : Purchase.all.map(&:sales).sum
    card_added = last_check ? Charge.where('created_at BETWEEN ? AND ?', last_check.created_at, Time.now).map(&:amount).sum : Charge.all.map(&:amount).sum
    withdraws = last_check ? Withdraw.where('created_at BETWEEN ? AND ?', last_check.created_at, Time.now).map(&:amount).sum : Withdraw.all.map(&:amount).sum
    returns = last_check ? Return.where('created_at BETWEEN ? AND ?', last_check.created_at, Time.now).map { |r| r.purchase.sales }.sum : Return.all.map { |r| r.purchase.sales }.sum

    amount = initial_cash_amount + sales + card_added - withdraws - returns

    Balance.new(amount: amount, sales: sales - returns, card_added: card_added)
  end
end
