# frozen_string_literal: true

class Balance < ApplicationRecord
  validates :amount, presence: true
  validates :sales, presence: true
  validates :card_added, presence: true

  def self.check
    last_check = Balance.last
    sales = Purchase.where('created_at BETWEEN ? AND ?', last_check.created_at, Time.now).map(&:sales).sum
    card_added = Charge.where('created_at BETWEEN ? AND ?', last_check.created_at, Time.now).map(&:amount).sum
    amount = last_check.amount + sales + card_added

    @balance = Balance.new(amount: amount, sales: sales, card_added: card_added)
    @balance if @balance.save
  end
end
