# frozen_string_literal: true

class Charge < ApplicationRecord
  validates :payment_method_id, presence: true
  validates :amount, presence: true
end
