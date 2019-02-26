# frozen_string_literal: true

class Withdraw < ApplicationRecord
  validates :amount, presence: true
end
