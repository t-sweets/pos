# frozen_string_literal: true

class PurchaseItem < ApplicationRecord
  # validates :purchase_id, presence: true
  validates :product_id, presence: true
  validates :quantity, presence: true
  validates :price, presence: true

  belongs_to :purchase
  belongs_to :product

  def allocate_stock
    product = Product.find(product_id)
    product.update(stock: product.stock - quantity) if product.stock
  end
end
