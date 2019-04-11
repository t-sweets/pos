# frozen_string_literal: true

class RegiCheck < ApplicationRecord
  validates :user_id, presence: true
  validates :regi_amount, presence: true
  validates :pos_regi_amount, presence: true
end
