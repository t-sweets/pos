# frozen_string_literal: true

class PurchaseItem < ApplicationRecord
  # validates :purchase_id, presence: true
  validates :product_id, presence: true
  validates :quantity, presence: true
  validates :price, presence: true
  validates :cost, presence: true

  belongs_to :purchase
  belongs_to :product

  def allocate_stock!
    product&.update!(stock: product.stock - quantity) if product.stock
    nofify_slack if product.notification && product.stock <= product.notification_stock
  end

  private

  def nofify_slack
    text = '`' + product.name + '` が残り `' + product.stock.to_s + '個` です！ 急いで買い出しに行きましょう！ :runner:'
    SlackUtil.post(ENV['SLACK_API_NOTIFY_CHANNEL'], text)
  end
end
