# frozen_string_literal: true

class Product < ApplicationRecord
  validates :name, presence: true
  validates :price, presence: true
  validates :image_path, presence: true
  validates :display, inclusion: { in: [true, false] }

  has_many :purchase_items, dependent: :restrict_with_error
  has_many :purchass, through: :purchase_items
  scope :active_all, -> { where(display: true) }
end
