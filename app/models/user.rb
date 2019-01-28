# frozen_string_literal: true

class User < ApplicationRecord
  devise :database_authenticatable, :registerable
  include DeviseTokenAuth::Concerns::User

  belongs_to :authority

  enum authority_id: {
    admin: 0,
    arriver: 1
  }
end
