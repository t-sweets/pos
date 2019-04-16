# frozen_string_literal: true

class RegiCheck < ApplicationRecord
  validates :user_id, presence: true
  validates :register_cash_amount, presence: true
  validates :pos_register_cash_amount, presence: true
end
