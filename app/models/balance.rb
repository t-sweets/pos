# frozen_string_literal: true

class Balance < ApplicationRecord
  validates :amount, presence: true
  validates :sales, presence: true
  validates :card_added, presence: true
end
