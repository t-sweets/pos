# frozen_string_literal: true

class Purchase < ApplicationRecord
  has_many :purchase_items, dependent: :destroy
  has_one :payment_methods
end
