# frozen_string_literal: true

class Deposit < ApplicationRecord
  validates :amount, presence: true
  validates :register_id, presence: true
end
