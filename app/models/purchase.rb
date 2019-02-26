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

  def receipt_to_slack
    icon_url = 'https://i.imgur.com/2aIp3nS.png'
    username = `Sweets決済Bot`

    item_hash = purchase_items.map do |item|
      [
        { value: item.product.name },
        { value: 'x' + item.quantity.to_s + '(@' + item.price.to_s + ')' }
      ]
    end.flatten

    attachments = [
      {
        title: 'sweets 1号店',
        fields: [
          {
            value: created_at.strftime('%Y/%m/%d %H:%M')
          },
          {
            value: '決済UUID: ' + format('%05d', id)
          }
        ]
      },
      {
        title: '---------------お買い上げ明細---------------',
        fields: item_hash
      },
      {
        fields: [
          {
            title: '合計',
            short: true
          },
          {
            value: '¥' + sales.to_s,
            short: true
          }
        ]
      }
    ]

    text = 'Thank you for shopping :tada:'

    Slack.chat_postMessage(text: text, attachments: attachments, username: username, channel: ENV['SLACK_API_RECEIPT_CHANNEL'], icon_url: icon_url)
  end
end
