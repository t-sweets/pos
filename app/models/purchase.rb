# frozen_string_literal: true

class Purchase < ApplicationRecord
  validates :payment_method_id, presence: true
  validates :payment_uuid, presence: true

  has_many :purchase_items, dependent: :nullify
  has_many :products, through: :purchase_items
  # has_many :audit_logs, as: :purchase
  belongs_to :payment_method

  def sales
    purchase_items.map { |item| item.price * item.quantity }.sum
  end

  def cancel
    purchase_items.each do |item|
      item.product.update(stock: item.product.stock + item.quantity)
      item.destroy
    end
    destroy
  end
end
