# frozen_string_literal: true

class Return < ApplicationRecord
  validates :purchase_id, presence: true

  belongs_to :purchase
end
