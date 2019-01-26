# frozen_string_literal: true

class Product < ApplicationRecord
  has_many :purchase_items, dependent: :restrict_with_error
  has_many :purchass, through: :purchase_items
  scope :active_all, -> { where(display: true) }
end
