# frozen_string_literal: true

class Token < ApplicationRecord
  validates :token, presence: true
  validates :payment_method_id, presence: true

  belongs_to :payment_method
end
