# frozen_string_literal: true

class Authority < ApplicationRecord
  validates :name, presence: true
  has_one :user

  def admin?
    name == 'admin'
  end

  def pos?
    name == 'pos'
  end

  def arriver?
    name == 'arriver'
  end
end
