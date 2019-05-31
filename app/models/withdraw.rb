# frozen_string_literal: true

class Withdraw < ApplicationRecord
  validates :amount, presence: true
  validates :register_id, presence: true
end
