# frozen_string_literal: true

class Balance < ApplicationRecord
  validates :amount, presence: true
  validates :sales, presence: true
  validates :card_added, presence: true

  def self.show
    _new_balance
  end

  def self.check
    @balance = _new_balance
    @balance if @balance.save
  end

  def self._new_balance
    last_check = Balance.last
    sales = Purchase.where('created_at BETWEEN ? AND ?', last_check.created_at, Time.now).map(&:sales).sum
    card_added = Charge.where('created_at BETWEEN ? AND ?', last_check.created_at, Time.now).map(&:amount).sum
    withdraws = Withdraw.where('created_at BETWEEN ? AND ?', last_check.created_at, Time.now).map(&:amount).sum
    amount = last_check.amount + sales + card_added - withdraws

    Balance.new(amount: amount, sales: sales, card_added: card_added)
  end
end
