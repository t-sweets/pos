class PurchaseItem < ApplicationRecord
  belongs_to :purchase
  belongs_to :product

  def allocate_stock
    product = Product.find(self.product_id)
    if product.stock
      product.update(stock: product.stock - self.quantity)
    end
  end
end
