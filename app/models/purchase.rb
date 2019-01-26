# frozen_string_literal: true

class Purchase < ApplicationRecord
  has_many :purchase_items, dependent: :destroy
  has_many :products, through: :purchase_items
  has_one :payment_methods
end
