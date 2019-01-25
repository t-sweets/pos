# frozen_string_literal: true

class PaymentMethod < ApplicationRecord
  has_many :purchases, dependent: :restrict_with_error
end
