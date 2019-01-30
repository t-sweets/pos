# frozen_string_literal: true

class Authority < ApplicationRecord
  validates :name, presence: true
  has_one :user
end
