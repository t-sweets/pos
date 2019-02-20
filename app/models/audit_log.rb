# frozen_string_literal: true

class AuditLog < ApplicationRecord
  validates :model, presence: true
  validates :model_id, presence: true
  validates :operation, presence: true
  validates :detail, presence: true

  # belongs_to :user, foreign_key: 'operator', class_name: 'User', polymorphic: true
  # belongs_to :product, polymorphic: true
  # belongs_to :payment_method, polymorphic: true
end
