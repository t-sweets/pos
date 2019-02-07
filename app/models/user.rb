# frozen_string_literal: true

class User < ApplicationRecord
  devise :database_authenticatable, :registerable
  include DeviseTokenAuth::Concerns::User

  validates :name, presence: true
  validates :email, presence: true
  validates :authority_id, presence: true

  enum authority_id: {
    admin: 0,
    arriver: 1,
    pos: 2
  }
end
