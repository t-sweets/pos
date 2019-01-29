# frozen_string_literal: true

class PaymentMethod < ApplicationRecord
  validates :name, presence: true
  validates :uuid, presence: true
  validates :addable, presence: true, inclusion: { in: [true, false] }

  has_many :purchases, dependent: :restrict_with_error
end
