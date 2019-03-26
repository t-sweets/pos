# frozen_string_literal: true

class Purchase < ApplicationRecord
  validates :payment_method_id, presence: true
  validates :payment_uuid, presence: true

  has_many :purchase_items, dependent: :nullify
  has_many :products, through: :purchase_items
  # has_many :audit_logs, as: :purchase
  belongs_to :payment_method

  scope :with_purchase_item, -> { includes(:purchase_items).references(:purchase_items) }

  scope :search_with_product_id, ->(product_id) { where('purchase_items.product_id = ?', product_id) }
  scope :spec_year, ->(year) { where('purchases.created_at BETWEEN ? AND ?', DateTime.new(year.to_i, 1, 1), DateTime.new(year.to_i, 12, -1)) }
  scope :spec_month, ->(month) { where('extract(month from purchases.created_at) = ?', month) }
  scope :spec_date, ->(year, month, day) { where('purchases.created_at BETWEEN ? AND ?', DateTime.new(year.to_i, month.to_i, day.to_i, 0, 0, 0, '+9'), DateTime.new(year.to_i, month.to_i, day.to_i, 23, 59, 59, '+9')) }
  scope :spec_range, ->(to, from) { where('purchases.created_at BETWEEN ? AND ?', from, to) }

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
    item_hash = purchase_items.map do |item|
      [
        { value: item.product.name },
        { value: 'x' + item.quantity.to_s + '(@' + item.price.to_s + ')', short: true },
        { value: '¥' + (item.quantity * item.price).to_s, short: true }
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
          },
          {
            value: '決済方法: ' + payment_method.name
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

    Slack.chat_postMessage(text: text, attachments: attachments, username: `Sweets決済Bot`, channel: ENV['SLACK_API_RECEIPT_CHANNEL'], icon_url: 'https://i.imgur.com/2aIp3nS.png')
  end
end
