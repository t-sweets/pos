# frozen_string_literal: true

class Purchase < ApplicationRecord
  validates :payment_method_id, presence: true
  validates :payment_uuid, presence: true

  has_many :purchase_items, dependent: :restrict_with_error
  has_many :products, through: :purchase_items
  belongs_to :payment_method

  def sales
    salse = purchase_items.map do |item|
      item.price * item.quantity
    end
    salse.sum
  end
end
