# frozen_string_literal: true

class Product < ApplicationRecord
  validates :name, presence: true
  validates :price, presence: true
  validates :image_path, presence: true
  validates :display, inclusion: { in: [true, false] }
  validates :notification, inclusion: { in: [true, false] }

  has_many :purchase_items, dependent: :restrict_with_error
  has_many :purchases, through: :purchase_items
  # has_many :audit_logs, as: :product

  scope :active_all, -> { where(display: true) }

  def add_stock!(params)
    update!(stock: stock + params[:additional_quantity])
  end

  def increase_price!(params)
    update!(price: price + params[:additional_quantity])
  end
end
