class Product < ApplicationRecord
  has_many :purchase_items, dependent: :restrict_with_error
  scope :active_all, -> { where(deleted: false) }
end
