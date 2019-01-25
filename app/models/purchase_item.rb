# frozen_string_literal: true

class PurchaseItem < ApplicationRecord
  belongs_to :purchase
  belongs_to :product

  def allocate_stock
    product = Product.find(product_id)
    product.update(stock: product.stock - quantity) if product.stock
  end
end
