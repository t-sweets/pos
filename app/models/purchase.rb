# frozen_string_literal: true

class Purchase < ApplicationRecord
  validates :payment_method_id, presence: true
  validates :payment_uuid, presence: true

  has_many :purchase_items, dependent: :restrict_with_error
  has_many :products, through: :purchase_items
  # has_many :audit_logs, as: :purchase
  belongs_to :payment_method
end
