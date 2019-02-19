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
    nofify_slack if product.notification && product.stock <= product.notification_stock
  end

  private

  def nofify_slack
    # TODO: summarize in slack module
    # attachments = ''
    text = '`' + product.name + '` が残り `' + product.stock.to_s + '個` です！ 急いで買い出しに行きましょう！ :runner:'
    Slack.chat_postMessage(text: text, username: 'pos', channel: '#prj_t_pay', icon_url: 'https://i.imgur.com/2aIp3nS.png')
  end
end
